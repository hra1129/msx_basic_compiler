// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_add.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_ADD::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_ADD::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	��ɍ�������
	this->p_left->compile( p_this );
	p_this->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_this );

	//	���̉��Z�q�̉��Z���ʂ̌^�����߂�
	this->type_adjust_2op( p_this, this->p_left, this->p_right );
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	�����̏ꍇ
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::STRING ) {
	}
	else {
		//	�����̏ꍇ
		p_this->assembler_list.add_label( "bios_decadd", "0x0269a" );
		p_this->assembler_list.add_label( "work_dac", "0x0f7f6" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decadd", COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "work_dac" );
		p_this->assembler_list.body.push_back( asm_line );
	}
}