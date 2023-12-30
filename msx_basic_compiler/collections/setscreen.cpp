// --------------------------------------------------------------------
//	Compiler collection: SetScreen
// ====================================================================
//	2023/Dec/30th	t.hara
// --------------------------------------------------------------------

#include "setscreen.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SETSCREEN
bool CSETSCREEN::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool has_type = false;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "SCREEN" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "blib_setscreen", "0x040d8" );
	asm_line.set( "LD", "", "IX", "blib_setscreen" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
