// --------------------------------------------------------------------
//	Expression operator Åè
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_OPERATOR_INTDIV_H__
#define __CEXPRESSION_OPERATOR_INTDIV_H__

// --------------------------------------------------------------------
//	Åè(èúéZ)
class CEXPRESSION_OPERATOR_INTDIV: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_INTDIV(): p_left(nullptr), p_right(nullptr) {
	}

	~CEXPRESSION_OPERATOR_INTDIV() {
		this->release();
	}

	void optimization( CCOMPILE_INFO *p_this );

	void compile( CCOMPILE_INFO *p_this );

	void release( void ) {
		if( this->p_left != nullptr ) {
			delete (this->p_left);
			this->p_left = nullptr;
		}
		if( this->p_right != nullptr ) {
			delete (this->p_right);
			this->p_right = nullptr;
		}
	}
};

#endif
