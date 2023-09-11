// --------------------------------------------------------------------
//	Compiler collection: Data
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "data.h"

// --------------------------------------------------------------------
//  DATA ƒf[ƒ^
bool CDATA::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "DATA" ) {
		return false;
	}
	p_info->list.p_position++;

	return true;
}
