// --------------------------------------------------------------------
//	Expression STR$
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_STR_H__
#define __EXPRESSION_STR_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_STR: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_STR() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand;

	void optimization( void );

	void compile( CCOMPILE_INFO *p_this );

	void release( void ) {
	}
};

#endif
