// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_inkey.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_INKEY::optimization( CCOMPILE_INFO *p_info ) {
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_INKEY::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	p_info->assembler_list.activate_copy_string();
	this->type = CEXPRESSION_TYPE::STRING;
	p_info->assembler_list.add_label( "blib_inkey", "0x0402a" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_inkey" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "copy_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
