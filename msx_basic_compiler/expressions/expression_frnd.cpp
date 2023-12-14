// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_frnd.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_FRND::optimization( CCOMPILE_INFO *p_info ) {

	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_FRND::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::INTEGER;
	p_info->assembler_list.add_label( "blib_frnd", "0x04081" );
	asm_line.set( "LD", "", "IX", "blib_frnd" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
}
