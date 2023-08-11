// --------------------------------------------------------------------
//	Expression operator +
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression.h"

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
