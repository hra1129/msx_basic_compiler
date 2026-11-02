// --------------------------------------------------------------------
//	Compiler collection: SetDateTime
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------

#include "setdatetime.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SET DATE <文字列式>
//  SET TIME <文字列式>
//	GET DATE/TIME の逆向き。書式は GET が返す形と同じ
//	(DATE は国IDによる並び、区切り '/'。TIME は "HH:MM:SS")。
//	実際の検証と RTC (RP-5C01) への書き込みは BACONLIB 側で行う。
bool CSETDATETIME::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool is_date;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ||
		( p_info->list.p_position->s_word != "DATE" && p_info->list.p_position->s_word != "TIME" ) ) {
		p_info->list.p_position--;
		return false;
	}
	is_date = ( p_info->list.p_position->s_word == "DATE" );
	p_info->list.p_position++;

	if( !exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	exp.release();
	p_info->assembler_list.activate_free_string();

	//	HL = 文字列ディスクリプタ
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	if( is_date ) {
		p_info->assembler_list.add_label( "blib_set_date", "0x04135" );
		asm_line.set( "LD", "", "IX", "blib_set_date" );
	}
	else {
		p_info->assembler_list.add_label( "blib_set_time", "0x04138" );
		asm_line.set( "LD", "", "IX", "blib_set_time" );
	}
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
