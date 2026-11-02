// --------------------------------------------------------------------
//	Expression: DEF FN call (inline expansion)
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include "expression_fncall.h"
#include "../compiler.h"

// --------------------------------------------------------------------
static CEXPRESSION_TYPE to_expression_type( CVARIABLE_TYPE var_type ) {
	switch( var_type ) {
	case CVARIABLE_TYPE::INTEGER:		return CEXPRESSION_TYPE::INTEGER;
	case CVARIABLE_TYPE::SINGLE_REAL:	return CEXPRESSION_TYPE::SINGLE_REAL;
	case CVARIABLE_TYPE::STRING:		return CEXPRESSION_TYPE::STRING;
	default:							return CEXPRESSION_TYPE::DOUBLE_REAL;
	}
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION_FNCALL::optimization( CCOMPILE_INFO *p_info ) {

	//	仮引数への代入という副作用を持つので最適化しない
	return nullptr;
}

// --------------------------------------------------------------------
//	呼び出しのコード生成:
//	1. 仮引数の旧値を待避する (インタプリタは呼び出し前の値を復元する。
//	   文字列は assign_string が旧内容を解放するため、複製して待避する)
//	2. 実引数を評価し、仮引数変数へ代入する (LET と同じ手順)
//	3. 定義本体の式をその場で評価する (実数結果は DAC へ実体化してから
//	   仮引数を復元する。本体が仮引数そのものを返す場合の破壊を防ぐ)
//	4. 仮引数の旧値を復元する
//	再帰呼び出しはコンパイル時に禁止している (展開時チェック)。
//	インタプリタでも再帰は実質破綻するため、コンパイルエラーにした。
void CEXPRESSION_FNCALL::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION_TYPE param_type;
	CVARIABLE param_variable;
	std::string s_label;
	std::string s_desc;
	int words, i;

	param_type = to_expression_type( this->param.type );
	s_label = this->param.s_label;

	//	1. 旧値の待避
	switch( this->param.type ) {
	case CVARIABLE_TYPE::INTEGER:
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[" + s_label + "]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::STRING:
		//	値の複製を作り、そのディスクリプタ (長さ+アドレス) を積む
		p_info->assembler_list.activate_copy_string();
		s_desc = p_info->get_auto_label() + "_desc";
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "copy_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY, "[HL]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY, "[HL]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY, "[HL]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	復元用ディスクリプタ置き場
		asm_line.set( "LABEL", "", s_desc, "" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		asm_line.set( "DEFB", "", "0", "" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		asm_line.set( "DEFW", "", "0", "" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::SINGLE_REAL:
	case CVARIABLE_TYPE::DOUBLE_REAL:
		words = (this->param.type == CVARIABLE_TYPE::SINGLE_REAL) ? 2 : 4;
		for( i = 0; i < words; i++ ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[" + s_label + " + " + std::to_string( i * 2 ) + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		break;
	default:
		break;
	}

	//	2. 実引数を仮引数へ代入
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->p_arg->compile( p_info );
	if( (param_type == CEXPRESSION_TYPE::STRING) != (this->p_arg->type == CEXPRESSION_TYPE::STRING) ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
	}
	else if( param_type != this->p_arg->type ) {
		this->p_arg->convert_type( p_info, param_type, this->p_arg->type );
	}
	param_variable = this->param;
	p_info->p_compiler->write_variable_value( param_variable );

	//	3. 本体を評価
	this->p_body->compile( p_info );
	if( (this->result_type == CEXPRESSION_TYPE::STRING) != (this->p_body->type == CEXPRESSION_TYPE::STRING) ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
	}
	else {
		//	実数結果は仮引数復元前に DAC へ実体化する
		if( this->p_body->type == CEXPRESSION_TYPE::SINGLE_REAL || this->p_body->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
			p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, (this->p_body->type == CEXPRESSION_TYPE::SINGLE_REAL) ? "4" : "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( this->result_type != this->p_body->type ) {
			this->p_body->convert_type( p_info, this->result_type, this->p_body->type );
		}
	}
	this->type = this->result_type;

	//	4. 旧値の復元
	switch( this->param.type ) {
	case CVARIABLE_TYPE::INTEGER:
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[SP]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[" + s_label + "]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::STRING:
		p_info->assembler_list.activate_assign_string();
		//	結果ディスクリプタを DE へ退避し、待避した複製でディスクリプタを組み直す
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "C" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[" + s_desc + "]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[" + s_desc + " + 1]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, s_desc );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "assign_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::SINGLE_REAL:
	case CVARIABLE_TYPE::DOUBLE_REAL:
		words = (this->param.type == CVARIABLE_TYPE::SINGLE_REAL) ? 2 : 4;
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		for( i = words - 1; i >= 0; i-- ) {
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[" + s_label + " + " + std::to_string( i * 2 ) + "]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		break;
	default:
		break;
	}
}
