// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_intdiv.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_INTDIV::optimization( CCOMPILE_INFO *p_this ) {
	
	this->p_left->optimization( p_this );
	this->p_right->optimization( p_this );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_INTDIV::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	��ɍ�������
	this->p_left->compile( p_this );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	�����̍��������^�łȂ���΁A�����^�ɕϊ�����
		this->convert_type( p_this, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_this->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_this );

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
	p_this->assembler_list.add_label( "bios_idiv", "0x031e6" );

	//	���̉��Z�q�������̏ꍇ
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_idiv", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
}
