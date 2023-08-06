// --------------------------------------------------------------------
//	Compiler collection: Defsng
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "defsng.h"

// --------------------------------------------------------------------
//  DEFSNG
bool CDEFSNG::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;

	if( p_info->list.p_position->s_word != "DEFSNG" ) {
		return false;
	}
	p_info->list.skip_statement();
	return true;
}
