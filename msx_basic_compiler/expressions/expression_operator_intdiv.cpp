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
void CEXPRESSION_OPERATOR_INTDIV::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_INTDIV::compile( CCOMPILE_INFO *p_this ) {
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

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚ÌŒ^‚ðŒˆ‚ß‚é
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	else if( this->p_left->type == this->p_right->type ) {
		//	¶‰E‚Ì€‚ª“¯‚¶Œ^‚È‚çA‚»‚ÌŒ^‚ðŒp³
		this->type = this->p_left->type;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	¶‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚Å¶‚ðÌ—p
		this->type = this->p_left->type;
	}
	else {
		//	‰E‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚Å‰E‚ðÌ—p
		this->type = this->p_right->type;
	}
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		p_this->assembler_list.add_label( "bios_idiv", "0x031e6" );

		//	‚±‚Ì‰‰ŽZŽq‚ª®”‚Ìê‡
		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "DE";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_this->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::CALL;
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		asm_line.operand1.s_value = "bios_idiv";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_this->assembler_list.body.push_back( asm_line );
	}
}
