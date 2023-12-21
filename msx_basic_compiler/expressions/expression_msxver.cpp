// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_msxver.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_MSXVER::optimization( CCOMPILE_INFO *p_info ) {
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_MSXVER::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	p_info->assembler_list.add_label( "work_romver", "0x002D" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[work_romver]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY, "0" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
