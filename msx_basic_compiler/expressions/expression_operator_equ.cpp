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
	p_this->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_this );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚Í•K‚¸®”
	this->type_adjust_2op( p_this, this->p_left, this->p_right );

	if( this->type == CEXPRESSION_TYPE::STRING ) {
		//	•¶Žš—ñ‚Ìê‡
		return;
	}
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	‚±‚Ì‰‰ŽZŽq‚ª®”‚Ìê‡
		std::string s_label = p_this->get_auto_label();

		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );	//	HL = DE ‚ª¬—§‚·‚éê‡‚Í HL=0:Z=1, ‚µ‚È‚¢ê‡‚Í HL!=0:Z=0
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );	//	HL = 0 ‚Ü‚½‚Í HL = -1
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );	//	HL = 0 ‚Ü‚½‚Í HL = -1
		p_this->assembler_list.body.push_back( asm_line );
	}
	else {
	}
}
