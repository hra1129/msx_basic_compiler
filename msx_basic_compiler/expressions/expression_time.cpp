// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_time.h"

// --------------------------------------------------------------------
void CEXPRESSION_TIME::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_TIME::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::INTEGER;
	p_this->assembler_list.add_label( "work_jiffy", "0x0fc9e" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[work_jiffy]" );
	p_this->assembler_list.body.push_back( asm_line );
}