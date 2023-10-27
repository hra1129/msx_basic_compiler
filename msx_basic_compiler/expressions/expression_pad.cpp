// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_pad.h"

// --------------------------------------------------------------------
void CEXPRESSION_PAD::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_PAD::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );

	p_info->assembler_list.add_label( "bios_gtpad", "0x00db" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bios_gtpad", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RLCA, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
