// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_left.h"

// --------------------------------------------------------------------
void CEXPRESSION_LEFT::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand1->optimization( p_info );
	this->p_operand2->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_LEFT::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand1->compile( p_info );

}
