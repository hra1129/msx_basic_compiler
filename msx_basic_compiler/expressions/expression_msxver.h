// --------------------------------------------------------------------
//	Expression MSXVER
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_MSXVER_H__
#define __EXPRESSION_MSXVER_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_MSXVER: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_MSXVER() {
		this->release();
	}

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};

#endif
