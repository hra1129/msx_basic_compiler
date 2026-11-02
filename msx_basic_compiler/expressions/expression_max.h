// --------------------------------------------------------------------
//	Expression MAX
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_MAX_H__
#define __EXPRESSION_MAX_H__

// --------------------------------------------------------------------
//	関数呼び出し
class CEXPRESSION_MAX: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_MAX() {
		this->release();
	}
	std::vector< CEXPRESSION_NODE* > operands;

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
		for( auto *p: this->operands ) {
			delete p;
		}
		this->operands.clear();
	}
};

#endif
