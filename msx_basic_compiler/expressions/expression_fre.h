// --------------------------------------------------------------------
//	Expression FRE
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_FRE_H__
#define __EXPRESSION_FRE_H__

// --------------------------------------------------------------------
//	�֐��Ăяo��
class CEXPRESSION_FRE: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_FRE() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand = nullptr;

	void optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
		if( this->p_operand != nullptr ) {
			delete this->p_operand;
			this->p_operand = nullptr;
		}
	}
};

#endif
