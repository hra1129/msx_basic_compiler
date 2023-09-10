// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_cdbl.h"

// --------------------------------------------------------------------
void CEXPRESSION_CDBL::optimization( CCOMPILE_INFO *p_info ) {

	this->p_operand->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_CDBL::compile( CCOMPILE_INFO *p_info ) {

	this->p_operand->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::DOUBLE_REAL, this->p_operand->type );
	this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
}
