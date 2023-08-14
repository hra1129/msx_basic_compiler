// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_term.h"
#include "../single_real.h"

// --------------------------------------------------------------------
void CEXPRESSION_TERM::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_TERM::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		int i = 0;
		sscanf_s( this->s_value.c_str(), "%i", &i );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		asm_line.operand2.s_value = std::to_string( i );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		CSINGLE_REAL value;
		value.set( this->s_value );
		std::string s_label = p_this->constants.add( value );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::LABEL;
		asm_line.operand2.s_value = s_label;
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		CDOUBLE_REAL value;
		value.set( this->s_value );
		std::string s_label = p_this->constants.add( value );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::LABEL;
		asm_line.operand2.s_value = s_label;
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::STRING ) {
		//	ÅöT.B.D.
	}
}
