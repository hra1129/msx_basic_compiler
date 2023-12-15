// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_irnd.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_IRND::optimization( CCOMPILE_INFO *p_info ) {

	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_IRND::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::INTEGER;
	p_info->assembler_list.add_label( "blib_irnd", "0x04081" );
	asm_line.set( "LD", "", "IX", "blib_irnd" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
}
