// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_not.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_NOT::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_NOT::compile( CCOMPILE_INFO *p_this ) {

	//	��ɍ�������
	this->p_right->compile( p_this );

	//	���̉��Z�q�̉��Z���ʂ̌^�����߂�
	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	�E���̍��������^�łȂ���΁A�����^�ɕϊ�����
		this->convert_type( p_this, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	���̉��Z�q�̌��ʂ͕K�������^
	this->type = CEXPRESSION_TYPE::INTEGER;
	CASSEMBLER_LINE asm_line;
	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "L";
	p_this->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::CPL;
	asm_line.operand1.type = COPERAND_TYPE::NONE;
	asm_line.operand1.s_value = "";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	p_this->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "L";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_this->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "H";
	p_this->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::CPL;
	asm_line.operand1.type = COPERAND_TYPE::NONE;
	asm_line.operand1.s_value = "";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	p_this->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "H";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_this->assembler_list.body.push_back( asm_line );
}
