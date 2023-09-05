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
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_CSRLIN: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_CSRLIN() {
		this->release();
	}

	void optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};

#endif
