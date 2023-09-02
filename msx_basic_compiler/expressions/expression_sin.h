// --------------------------------------------------------------------
//	Expression SIN
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_SIN_H__
#define __EXPRESSION_SIN_H__

// --------------------------------------------------------------------
//	�֐��Ăяo��
class CEXPRESSION_SIN: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_SIN() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand = nullptr;

	void optimization( CCOMPILE_INFO *p_this );

	void compile( CCOMPILE_INFO *p_this );

	void release( void ) {
		if( this->p_operand != nullptr ) {
			delete this->p_operand;
			this->p_operand = nullptr;
		}
	}
};

#endif