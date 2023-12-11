// --------------------------------------------------------------------
//	Compiler collection: Pset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "pset.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PSET (X,Y),C
bool CPSET::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp, exp_x, exp_y;
	bool has_step = false;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "PSET" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		//	PSET だけで終わってる場合は Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_pset", "0x057F5" );
	p_info->assembler_list.add_label( "bios_setatr", "0x0011A" );

	//	X座標
	exp_x.makeup_node( p_info );
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	Y座標
	exp_y.makeup_node( p_info );
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")"){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	PSET(x,y) の場合
		//	ロジカルオペレーションは PSET固定
		p_info->assembler_list.add_label( "work_logopr", "0x0fB02" );
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_logopr]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		//	色は前景色になる
		p_info->assembler_list.add_label( "work_forclr", "0x0F3E9" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_forclr]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_setatr", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	X座標
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	Y座標
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_pset", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	色
	if( p_info->list.is_command_end() ) {
		//	PSET(x,y), で終わってるのでエラー
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_setatr", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	ロジカルオペレーション
		p_info->p_compiler->put_logical_operation();
		//	X座標
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	Y座標
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_pset", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		return true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->errors.add( SYNTAX_ERROR, line_no );
	return true;
}
