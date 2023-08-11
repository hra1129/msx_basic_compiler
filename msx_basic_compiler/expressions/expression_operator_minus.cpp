// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_minus.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MINUS::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MINUS::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚É€‚ðˆ—
	this->p_right->compile( p_this );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚ÌŒ^‚ðŒˆ‚ß‚é
	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	//	‚±‚Ì‰‰ŽZŽq‚ÌŒ‹‰Ê‚Í•K‚¸®”Œ^
	this->type = CEXPRESSION_TYPE::INTEGER;
	if( this->p_right->type == CEXPRESSION_TYPE::INTEGER ) {
		//	®”‚Ìê‡
		asm_line.type = CMNEMONIC_TYPE::EX;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "DE";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "HL";
		p_this->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::XOR;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "H";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_this->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_this->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::SBC;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "DE";
		p_this->assembler_list.body.push_back( asm_line );
	}
}
