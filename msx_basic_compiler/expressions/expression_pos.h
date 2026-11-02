// --------------------------------------------------------------------
//	Expression POS
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_POS_H__
#define __EXPRESSION_POS_H__

// --------------------------------------------------------------------
//	関数呼び出し
class CEXPRESSION_POS: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_POS() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand = nullptr;

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
		if( this->p_operand != nullptr ) {
			delete this->p_operand;
			this->p_operand = nullptr;
		}
	}
};

#endif
