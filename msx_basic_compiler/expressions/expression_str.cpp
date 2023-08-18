// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_str.h"

// --------------------------------------------------------------------
void CEXPRESSION_STR::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_STR::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_this );

	if( this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
		p_this->assembler_list.add_label( "work_dac_int", "0x0f7f8" );
		p_this->assembler_list.add_label( "work_valtyp", "0x0f663" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]", COPERAND_TYPE::REGISTER, "HL" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
		p_this->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->p_operand->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		void activate_ld_dac_single_real( void );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_single_real", COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else if( this->p_operand->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		void activate_ld_dac_double_real( void );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_double_real", COPERAND_TYPE::NONE, "" );
		p_this->assembler_list.body.push_back( asm_line );
	}
	else {
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}

	p_this->assembler_list.activate_str();
	this->type = CEXPRESSION_TYPE::STRING;
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "str", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
}
