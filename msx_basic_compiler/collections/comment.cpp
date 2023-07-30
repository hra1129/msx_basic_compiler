// --------------------------------------------------------------------
//	Compiler collection: Comment
// ====================================================================
//	2023/July/24th	t.hara
// --------------------------------------------------------------------

#include "comment.h"

// --------------------------------------------------------------------
//  ' comment
//  REM comment
bool CCOMMENT::exec( class CCOMPILER *p_this ) {
	std::string s;

	p_this->update_current_line_no();
	if( p_this->p_position->s_word != "'" && p_this->p_position->s_word != "REM" ) {
		return false;
	}
	p_this->p_position++;
	if( p_this->is_line_end() ) {
		//	' �� REM �����ŏI����Ă�ꍇ
		s = "";
	}
	else {
		//	�R�����g�̒��g���������ꍇ
		s = p_this->p_position->s_word;
		p_this->p_position++;
	}
	//	�ϐ��𐶐�����
	

}
