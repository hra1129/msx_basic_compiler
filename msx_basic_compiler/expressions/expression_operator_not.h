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
//	NOT(”Û’è)
class CEXPRESSION_OPERATOR_NOT: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_NOT(): p_right(nullptr) {
	}

	~CEXPRESSION_OPERATOR_NOT() {
		this->release();
	}

	void optimization( void );

	void compile( CCOMPILE_INFO *p_this );

	void release( void ) {
		if( this->p_right != nullptr ) {
			delete (this->p_right);
			this->p_right = nullptr;
		}
	}
};
