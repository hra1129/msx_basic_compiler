// --------------------------------------------------------------------
//	Expression FRND
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_FRND_H__
#define __EXPRESSION_FRND_H__

// --------------------------------------------------------------------
//	関数呼び出し
class CEXPRESSION_FRND: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_FRND() {
		this->release();
	}

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};

#endif
