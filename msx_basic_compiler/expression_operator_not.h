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
//	NOT(”Û’è)
class CEXPRESSION_OPERATOR_NOT: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_right;

	void optimization( void );

	void compile( CCOMPILER *p_this );
};
