// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_ge.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_GE::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_left->optimization( p_info );
	this->p_right->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_GE::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION_TYPE compare_type;

	//	��ɍ�������
	this->p_left->compile( p_info );
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );

	//	���̉��Z�q�̉��Z���ʂ͕K������
	this->type_adjust_2op( p_info, this->p_left, this->p_right );


	//	���̉��Z�q�̉��Z���ʂ͕K������
	if( this->p_left->type != this->p_right->type && (this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING) ) {
		//	���E�̍����قȂ�^�ŁA�Е���������^�Ȃ�G���[
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	���̕����^���傫���̂ŁA�E�̕��̌^�������ɍ��킹��
		compare_type = this->p_left->type;
	}
	else {
		//	�E�̕����^���傫���̂ŁA���̕��̌^���E���ɍ��킹��
		compare_type = this->p_right->type;
	}
	if( compare_type == CEXPRESSION_TYPE::INTEGER ) {
		//	���̉��Z�q�������̏ꍇ
		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "DE";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::EX;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "DE";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "HL";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::XOR;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::SBC;					//	HL(����) >= DE(�E��) ����������ꍇ�� Cy=0, ���Ȃ��ꍇ�� Cy=1
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "DE";
		p_info->assembler_list.body.push_back( asm_line );

		std::string s_label = p_info->get_auto_label();
		asm_line.type = CMNEMONIC_TYPE::JR;
		asm_line.condition = CCONDITION::C;
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		asm_line.operand1.s_value = s_label;
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::DEC;
		asm_line.condition = CCONDITION::NONE;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LABEL;
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		asm_line.operand1.s_value = s_label;
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;						//	HL = 0 �܂��� HL = -1
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "H";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_info->assembler_list.body.push_back( asm_line );
	}
	this->type = CEXPRESSION_TYPE::INTEGER;
}
