// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_term.h"

// --------------------------------------------------------------------
void CEXPRESSION_TERM::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_TERM::compile( CCOMPILE_INFO *p_this ) {

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		int i = 0;
		sscanf_s( this->s_value.c_str(), "%i", &i );
		CASSEMBLER_LINE asm_line;
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		asm_line.operand2.s_value = std::to_string( i );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		//	ÅöT.B.D.
	}
	else if( this->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		//	ÅöT.B.D.
	}
	else if( this->type == CEXPRESSION_TYPE::STRING ) {
		//	ÅöT.B.D.
	}
}
