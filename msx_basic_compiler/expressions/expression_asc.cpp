// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_asc.h"

// --------------------------------------------------------------------
void CEXPRESSION_ASC::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_ASC::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_REGISTER, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_REGISTER, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY_REGISTER, "0" );
	p_info->assembler_list.body.push_back( asm_line );

	this->type = CEXPRESSION_TYPE::INTEGER;
}
