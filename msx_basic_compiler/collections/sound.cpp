// --------------------------------------------------------------------
//	Compiler collection: Sound
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "sound.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SOUND <PSG���W�X�^�ԍ�>, <�������ޒl>
bool CSOUND::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	bool has_parameter;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "SOUND" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_wrtpsg", "0x00093" );

	CEXPRESSION exp;
	//	��1���� <PSG���W�X�^�ԍ�>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		asm_line.type = CMNEMONIC_TYPE::PUSH;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		exp.release();
		has_parameter = true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	��2���� <�������ޒl>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "E";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}

	asm_line.type = CMNEMONIC_TYPE::CALL;
	asm_line.operand1.s_value = "bios_wrtpsg";
	asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
	asm_line.operand2.s_value = "";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
