// --------------------------------------------------------------------
//	Compiler collection: SetScroll
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "setscroll.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SETSCROLL 水平スクロール位置, 垂直スクロール位置, マスクモード, ページモード
bool CSETSCROLL::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	int enable = 0x0F;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "SCROLL" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	//	引数の処理
	if( exp.compile( p_info ) ) {
		//	水平スクロール
		exp.release();
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		enable &= 0x0E;
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		enable &= 0x01;
	}
	else {
		p_info->list.p_position++;
		if( exp.compile( p_info ) ) {
		//	垂直スクロール
		exp.release();
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			enable &= 0x0D;
		}
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		enable &= 0x03;
	}
	else {
		p_info->list.p_position++;
		if( exp.compile( p_info ) ) {
		//	マスク
		exp.release();
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			enable &= 0x0B;
		}
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		enable &= 0x07;
	}
	else {
		p_info->list.p_position++;
		if( exp.compile( p_info ) ) {
		//	ページ
			exp.release();
		}
		else {
			enable &= 0x07;
		}
	}
	if( (enable & 0x08) != 0 ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "L" );
			p_info->assembler_list.body.push_back( asm_line );
	}
	if( (enable & 0x04) != 0 ) {
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	if( (enable & 0x02) != 0 ) {
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	if( (enable & 0x01) != 0 ) {
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, std::to_string( enable ) );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->assembler_list.add_label( "blib_setscroll", "0x0403f" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::CONSTANT, "blib_setscroll" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
