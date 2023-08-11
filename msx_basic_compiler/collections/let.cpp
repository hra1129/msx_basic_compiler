// --------------------------------------------------------------------
//	Compiler collection: Let
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "let.h"

// --------------------------------------------------------------------
//  [LET] {�ϐ���}[(�z��v�f, �z��v�f ...)] = ��
bool CLET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;

	if( p_info->list.p_position->s_word == "LET" ) {
		p_info->list.p_position++;
		if( p_info->list.is_end() || p_info->list.p_position->line_no != line_no ) {
			//	LET �����ŏI����Ă�ꍇ�� Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		has_let = true;
	}
	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	�ϐ����ł͖����̂ő���ł͖���
		if( has_let ) {
			//	LET �����ŏI����Ă�ꍇ�� Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		return false;
	}
	//	�ϐ��𐶐�����


	return true;
}
