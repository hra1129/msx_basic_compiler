// --------------------------------------------------------------------
//	Expression ERR / ERL
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_ERR_H__
#define __EXPRESSION_ERR_H__

class CEXPRESSION_ERR: public CEXPRESSION_NODE {
public:
	void release( void ) {
	}
	CEXPRESSION_NODE *optimization( CCOMPILE_INFO *p_info );
	void compile( CCOMPILE_INFO *p_info );
};

class CEXPRESSION_ERL: public CEXPRESSION_NODE {
public:
	void release( void ) {
	}
	CEXPRESSION_NODE *optimization( CCOMPILE_INFO *p_info );
	void compile( CCOMPILE_INFO *p_info );
};

#endif
