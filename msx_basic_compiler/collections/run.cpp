// --------------------------------------------------------------------
//	Compiler collection: Run
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "run.h"

// --------------------------------------------------------------------
//  RUN [�s�ԍ�]
bool CRUN::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	std::string s_label;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "RUN" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		//	RUN �P�Ƃ̎��s�̏ꍇ
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "program_start" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "program_run", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
		//	RUN {�s�ԍ�} �̎��s�̏ꍇ
		if( p_info->list.p_position->s_word[0] == '*' ) {
			s_label = "label_" + p_info->list.p_position->s_word.substr(1);
		}
		else {
			s_label = "line_" + p_info->list.p_position->s_word;
		}
		p_info->list.p_position++;
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "program_run", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	//	RUN �t�@�C���� �̎��s�̏ꍇ (�� RUN �t�@�C����,R �ɂ͔�Ή�)
	//	��T.B.D.
	return true;
}
