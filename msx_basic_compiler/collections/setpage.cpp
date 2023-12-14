// --------------------------------------------------------------------
//	Compiler collection: SetPage
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "setpage.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SETPAGE 表示ページ, 描画ページ
bool CSETPAGE::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool has_parameter = false;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "PAGE" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "subrom_setpag", "0x013d" );
	p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	//	引数の処理
	if( exp.compile( p_info ) ) {
		//	表示ページ
		exp.release();
		p_info->assembler_list.add_label( "work_dppage", "0x0faf5" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_dppage]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		has_parameter = true;
	}
	else {
		has_parameter = false;
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		if( !has_parameter ) {
			p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
			return true;
		}
	}
	if( exp.compile( p_info ) ) {
		//	描画ページ
		exp.release();
		p_info->assembler_list.add_label( "work_acpage", "0x0faf6" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_acpage]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		has_parameter = true;
	}
	else {
		has_parameter = false;
	}

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::CONSTANT, "subrom_setpag" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_extrom", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
