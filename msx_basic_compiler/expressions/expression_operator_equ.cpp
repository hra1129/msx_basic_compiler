// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_equ.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_EQU::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_EQU::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_this );

	asm_line.type = CMNEMONIC_TYPE::PUSH;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "HL";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	p_this->assembler_list.body.push_back( asm_line );

	this->p_right->compile( p_this );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚Í•K‚¸®”
	this->type = CEXPRESSION_TYPE::INTEGER;
	if( this->p_left->type != this->p_right->type && (this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING) ) {
		//	¶‰E‚Ì€‚ªˆÙ‚È‚éŒ^‚ÅA•Ð•û‚ª•¶Žš—ñŒ^‚È‚çƒGƒ‰[
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	¶‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚ÅA‰E‚Ì•û‚ÌŒ^‚ð¶€‚É‡‚í‚¹‚é
		this->type = this->p_left->type;
	}
	else {
		//	‰E‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚ÅA¶‚Ì•û‚ÌŒ^‚ð‰E€‚É‡‚í‚¹‚é
		this->type = this->p_right->type;
	}
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	‚±‚Ì‰‰ŽZŽq‚ª®”‚Ìê‡
		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "DE";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_this->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::ADD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "DE";
		p_this->assembler_list.body.push_back( asm_line );
	}
}
