// --------------------------------------------------------------------
//	Compiler collection: Key
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "key.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  KEY ファンクションキー制御
bool CKEY::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	std::vector< CBASIC_WORD >::const_iterator p_position;

	//	KEY(n) {ON|OFF|STOP} は ON KEY のところで処理するので、ここの対象外の命令だったら戻せるように覚えておく
	p_position = p_info->list.p_position;
	if( p_info->list.p_position->s_word != "KEY" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return false;
	}

	if( p_info->list.p_position->s_word == "(" ) {
		//	KEY(n) はここの対象外。
		p_info->list.p_position = p_position;
		return false;
	}
	if( p_info->list.p_position->s_word == "ON" ) {
		p_info->assembler_list.add_label( "bios_dspfnk", "0x000CF" );
		asm_line.set( "CALL", "", "bios_dspfnk" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else if( p_info->list.p_position->s_word == "OFF" ) {
		p_info->assembler_list.add_label( "bios_erafnk", "0x000CC" );
		asm_line.set( "CALL", "", "bios_erafnk" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else if( p_info->list.p_position->s_word == "LIST" ) {
		p_info->assembler_list.add_label( "blib_key_list", "0x04018" );
		asm_line.set( "LD", "", "ix", "blib_key_list" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else if( exp.compile( p_info ) ) {
		p_info->assembler_list.activate_free_string();
		exp.release();
		p_info->assembler_list.add_label( "blib_set_function_key", "0x040e1" );
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		if( !exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		exp.release();
		asm_line.set( "POP", "", "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "ix", "blib_set_function_key" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "free_string" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
