// --------------------------------------------------------------------
//	Compiler collection: Width
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "width.h"

// --------------------------------------------------------------------
//  WIDTH {•}
bool CRUN::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "WIDTH" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, p_info->line.get_line_no() );
		return true;
	}
	return true;
}
