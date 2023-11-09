// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_fre.h"

// --------------------------------------------------------------------
void CEXPRESSION_FRE::optimization( CCOMPILE_INFO *p_info ) {

	this->p_operand->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_FRE::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_end]" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]" );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
