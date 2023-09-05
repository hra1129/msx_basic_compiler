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
class CEXPRESSION_FUNCTION: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_FUNCTION() {
		this->release();
	}

	void optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};
