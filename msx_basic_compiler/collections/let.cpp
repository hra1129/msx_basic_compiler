// --------------------------------------------------------------------
//	Compiler collection: Let
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "let.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LET] {変数名}[(配列要素, 配列要素 ...)] = 式
bool CLET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word == "LET" ) {
		p_info->list.p_position++;
		if( p_info->list.is_end() || p_info->list.p_position->line_no != line_no ) {
			//	LET だけで終わってる場合は Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		has_let = true;
	}
	
	if( p_info->list.p_position->s_word == "TIME" ) {
		//	TIMEシステム変数への代入
		p_info->list.p_position++;
		if( !p_info->list.check_word( &(p_info->errors), "=" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
			p_info->assembler_list.add_label( "work_jiffy", "0x0fc9e" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_jiffy]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		return true;
	}
	else if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	変数名では無いので LET ではない。
		if( has_let ) {
			//	LET だけで終わってる場合は Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		return false;
	}
	//	変数を生成する
	CVARIABLE variable = p_info->variable_manager.get_variable_info( p_info );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, variable.s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	代入処理
	if( !p_info->list.check_word( &(p_info->errors), "=" ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	//	右辺の処理
	CEXPRESSION_TYPE exp_type;
	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		exp_type = CEXPRESSION_TYPE::INTEGER;		break;
	case CVARIABLE_TYPE::SINGLE_REAL:	exp_type = CEXPRESSION_TYPE::SINGLE_REAL;	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	exp_type = CEXPRESSION_TYPE::DOUBLE_REAL;	break;
	case CVARIABLE_TYPE::STRING:		exp_type = CEXPRESSION_TYPE::STRING;		break;
	}
	if( exp.compile( p_info, exp_type ) ) {
		switch( variable.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::SINGLE_REAL:
			p_info->assembler_list.activate_ld_de_single_real();
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_single_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::DOUBLE_REAL:
			p_info->assembler_list.activate_ld_de_double_real();
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_double_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::STRING:
			break;
		}
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
	}
	return true;
}
