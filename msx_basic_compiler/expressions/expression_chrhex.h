// --------------------------------------------------------------------
//	Expression CHRHEX$
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_CHRHEX_H__
#define __EXPRESSION_CHRHEX_H__

// --------------------------------------------------------------------
//	関数呼び出し
class CEXPRESSION_CHRHEX: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_CHRHEX() {
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
