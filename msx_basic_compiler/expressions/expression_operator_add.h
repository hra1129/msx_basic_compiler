// --------------------------------------------------------------------
//	Expression operator +
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_OPERATOR_ADD_H__
#define __CEXPRESSION_OPERATOR_ADD_H__

// --------------------------------------------------------------------
//	+(‰ÁŽZ)
class CEXPRESSION_OPERATOR_ADD: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;

	CEXPRESSION_OPERATOR_ADD(): p_left(nullptr), p_right(nullptr) {
	}

	~CEXPRESSION_OPERATOR_ADD() {
		this->release();
	}

	void optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

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

	void activate_str_add( CCOMPILE_INFO *p_info );
};

#endif
