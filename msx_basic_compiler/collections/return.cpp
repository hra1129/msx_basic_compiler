// --------------------------------------------------------------------
//	Compiler collection: Return
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "return.h"

// --------------------------------------------------------------------
//  RETURN
bool CRETURN::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	std::string s_label;

	if( p_info->list.p_position->s_word != "RETURN" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_line_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
		//	RETURN だけで終わってる場合は RET だけ。
		asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	行番号が続いてる場合は、戻り番地を捨てて指定の行にジャンプする。
		p_info->use_return_line_no = true;

		if( p_info->list.p_position->s_word[0] == '*' ) {
			asm_line.set( "LD", "", "BC", "label_" + p_info->list.p_position->s_word.substr(1) );
		}
		else {
			asm_line.set( "LD", "", "BC", "line_" + p_info->list.p_position->s_word );
		}
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "JP", "", "_return_line_num" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	return true;
}
