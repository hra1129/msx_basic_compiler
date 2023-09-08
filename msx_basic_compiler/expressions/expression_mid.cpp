// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_mid.h"

// --------------------------------------------------------------------
void CEXPRESSION_MID::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand1->optimization( p_info );
	this->p_operand2->optimization( p_info );
	if( this->p_operand3 != nullptr ) {
		this->p_operand3->optimization( p_info );
	}
}

// --------------------------------------------------------------------
void CEXPRESSION_MID::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand1->compile( p_info );



}
