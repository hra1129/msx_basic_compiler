// --------------------------------------------------------------------
//	Expression operator +
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "compiler.h"
#include "expression.h"

// --------------------------------------------------------------------
//	+(���Z)
class CEXPRESSION_OPERATOR_ADD: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_ADD(): p_left(nullptr), p_right(nullptr) {
	}

	void optimization( void );

	void compile( CCOMPILER *p_this );
};
