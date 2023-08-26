// --------------------------------------------------------------------
//	Expression operator Variable
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_VARIABLE_H__
#define __CEXPRESSION_VARIABLE_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_VARIABLE: public CEXPRESSION_NODE {
public:
	std::string s_value;
	CVARIABLE variable;

	~CEXPRESSION_VARIABLE() {
		this->release();
	}

	void optimization( CCOMPILE_INFO *p_this );

	void compile( CCOMPILE_INFO *p_this );

	void release( void ) {
	}
};

#endif
