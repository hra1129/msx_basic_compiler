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

	CASSEMBLER_LINE asm_line;
	asm_line.type = CMNEMONIC_TYPE::COMMENT;
	asm_line.operand1.s_value = s;
	asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
