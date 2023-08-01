// --------------------------------------------------------------------
//	Expression operator EQV
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "compiler.h"
#include "expression.h"

// --------------------------------------------------------------------
//	<= =< (¬‚È‚èˆê’v)
class CEXPRESSION_OPERATOR_LE: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_LE(): p_left(nullptr), p_right(nullptr) {
	}

	void optimization( void );

	void compile( CCOMPILER *p_this );
};
