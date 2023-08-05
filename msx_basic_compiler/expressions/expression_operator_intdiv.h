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
//	Åè(èúéZ)
class CEXPRESSION_OPERATOR_INTDIV: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_INTDIV(): p_left(nullptr), p_right(nullptr) {
	}

	void optimization( void );

	void compile( CCOMPILE_INFO *p_this );
};
