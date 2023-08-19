// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_stick.h"

// --------------------------------------------------------------------
void CEXPRESSION_STICK::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_STICK::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	��Ɉ���������
	this->p_operand->compile( p_this );
	this->p_operand->convert_type( p_this, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );

	p_this->assembler_list.add_label( "bios_gtstck", "0x00d5" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "L" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bios_gtstck", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY_REGISTER, "0" );
	p_this->assembler_list.body.push_back( asm_line );
}
