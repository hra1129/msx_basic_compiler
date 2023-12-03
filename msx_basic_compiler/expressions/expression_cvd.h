// --------------------------------------------------------------------
//	Expression CVD
// ====================================================================
//	2023/Dec/03rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_CVD_H__
#define __EXPRESSION_CVD_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_CVD: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_CVD() {
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
