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
//	ä÷êîåƒÇ—èoÇµ
class CEXPRESSION_VARIABLE: public CEXPRESSION_NODE {
public:
	std::string s_value;
	CVARIABLE variable;
	std::vector< CEXPRESSION* > exp_list;
	bool no_copy = false;

	~CEXPRESSION_VARIABLE() {
		this->release();
	}

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};

#endif
