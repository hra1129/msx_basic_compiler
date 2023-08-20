// --------------------------------------------------------------------
//	Expression operator Term
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_TERM_H__
#define __CEXPRESSION_TERM_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_TERM: public CEXPRESSION_NODE {
public:
	std::string s_value;

	~CEXPRESSION_TERM() {
		this->release();
	}

	void optimization( void );

	void compile( CCOMPILE_INFO *p_this );

	void release( void ) {
	}
};

#endif
