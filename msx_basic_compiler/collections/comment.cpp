// --------------------------------------------------------------------
//	Compiler collection: Comment
// ====================================================================
//	2023/July/24th	t.hara
// --------------------------------------------------------------------

#include "comment.h"

// --------------------------------------------------------------------
//  ' comment
//  REM comment
bool CCOMMENT::exec( CCOMPILE_INFO *p_info ) {
	std::string s;

	p_info->list.update_current_line_no();
	if( p_info->list.p_position->s_word != "'" && p_info->list.p_position->s_word != "REM" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_line_end() ) {
		//	' �� REM �����ŏI����Ă�ꍇ
		s = "";
	}
	else {
		//	�R�����g�̒��g���������ꍇ
		s = p_info->list.p_position->s_word;
		p_info->list.p_position++;
	}
	return true;
}
