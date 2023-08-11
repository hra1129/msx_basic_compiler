// --------------------------------------------------------------------
//	Compiler collection: Let
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "let.h"

// --------------------------------------------------------------------
//  [LET] {変数名}[(配列要素, 配列要素 ...)] = 式
bool CLET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;

	if( p_info->list.p_position->s_word == "LET" ) {
		p_info->list.p_position++;
		if( p_info->list.is_end() || p_info->list.p_position->line_no != line_no ) {
			//	LET だけで終わってる場合は Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		has_let = true;
	}
	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	変数名では無いので代入では無い
		if( has_let ) {
			//	LET だけで終わってる場合は Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		return false;
	}
	//	変数を生成する


	return true;
}
