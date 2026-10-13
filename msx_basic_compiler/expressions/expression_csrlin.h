// --------------------------------------------------------------------
//	Expression CSRLIN
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_CSRLIN_H__
#define __EXPRESSION_CSRLIN_H__

// --------------------------------------------------------------------
//	関数呼び出し
class CEXPRESSION_CSRLIN: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_CSRLIN() {
		this->release();
	}

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};

#endif
