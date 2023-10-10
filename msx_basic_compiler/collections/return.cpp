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
		//	RETURN �����ŏI����Ă�ꍇ�� RET �����B
		asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	�s�ԍ��������Ă�ꍇ�́A�߂�Ԓn���̂ĂĎw��̍s�ɃW�����v����B
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "interrupt_prcess" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::C, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "interrupt_prcess_end" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NC, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		//	���荞�݂���߂� RETURN �������ꍇ�́A���荞�ݏ������[�`���Ăяo���̃X�^�b�N���p������
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
