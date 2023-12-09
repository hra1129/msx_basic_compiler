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
	CEXPRESSION_TERM() {
		this->is_constant = true;
	}

	~CEXPRESSION_TERM() {
		this->release();
	}

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	double get_value( void );
	void set_type( CEXPRESSION_TYPE type1, CEXPRESSION_TYPE type2 );
	void set_double( double r );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
	}
};

#endif
