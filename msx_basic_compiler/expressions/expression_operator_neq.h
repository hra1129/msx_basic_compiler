// --------------------------------------------------------------------
//	Expression operator +
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression.h"

// --------------------------------------------------------------------
//	<> ><(•sˆê’v)
class CEXPRESSION_OPERATOR_NEQ: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_NEQ(): p_left(nullptr), p_right(nullptr) {
	}

	void optimization( void );

	void compile( CCOMPILE_INFO *p_this );
};
