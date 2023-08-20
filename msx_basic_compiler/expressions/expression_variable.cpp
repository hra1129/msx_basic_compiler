// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_variable.h"

// --------------------------------------------------------------------
void CEXPRESSION_VARIABLE::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_VARIABLE::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	if( this->variable.type == CVARIABLE_TYPE::UNKNOWN ) {
		p_this->errors.add( SYNTAX_ERROR, p_this->list.get_line_no() );
	}
	else if( this->variable.type == CVARIABLE_TYPE::INTEGER || this->variable.type == CVARIABLE_TYPE::STRING ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + this->variable.s_label + "]" );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, this->variable.s_label );
		p_this->assembler_list.body.push_back( asm_line );
	}
}
