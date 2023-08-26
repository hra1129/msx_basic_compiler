// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_csrlin.h"

// --------------------------------------------------------------------
void CEXPRESSION_CSRLIN::optimization( CCOMPILE_INFO *p_this ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_CSRLIN::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::INTEGER;
	p_this->assembler_list.add_label( "work_csry", "0x0f3dc" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[work_csry]" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::CONSTANT, "0" );
	p_this->assembler_list.body.push_back( asm_line );
}
