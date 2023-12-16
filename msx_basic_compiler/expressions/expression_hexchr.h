// --------------------------------------------------------------------
//	Expression HEXCHR$
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_HEXCHR_H__
#define __EXPRESSION_HEXCHR_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_HEXCHR: public CEXPRESSION_NODE {
private:
	int hexchr( int c );

public:
	~CEXPRESSION_HEXCHR() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand = nullptr;

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
		if( this->p_operand != nullptr ) {
			delete this->p_operand;
			this->p_operand = nullptr;
		}
	}
};

#endif
