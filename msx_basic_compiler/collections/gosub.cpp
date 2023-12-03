// --------------------------------------------------------------------
//	Compiler collection: Gosub
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "gosub.h"

// --------------------------------------------------------------------
//  GOSUB 行番号
bool CGOSUB::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "GOSUB" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	GOSUB だけで終わってる場合は Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
		//	行番号指定がおかしい場合は Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( p_info->list.p_position->s_word[0] == '*' ) {
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "label_" + p_info->list.p_position->s_word.substr(1), COPERAND_TYPE::NONE, "" );
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
	}
	p_info->assembler_list.body.push_back( asm_line );
	p_info->list.p_position++;
	return true;
}
