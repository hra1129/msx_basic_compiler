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
//	�֐��Ăяo��
class CEXPRESSION_TERM: public CEXPRESSION_NODE {
public:
	void optimization( void );

	void compile( CCOMPILE_INFO *p_this );
};
