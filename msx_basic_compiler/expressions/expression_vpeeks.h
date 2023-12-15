// --------------------------------------------------------------------
//	Expression VPEEKS
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_VPEEKS_H__
#define __EXPRESSION_VPEEKS_H__

// --------------------------------------------------------------------
//	ŠÖ”ŒÄ‚Ño‚µ
class CEXPRESSION_VPEEKS: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_VPEEKS() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand1 = nullptr;
	CEXPRESSION_NODE *p_operand2 = nullptr;

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
		if( this->p_operand1 != nullptr ) {
			delete this->p_operand1;
			this->p_operand1 = nullptr;
		}
		if( this->p_operand2 != nullptr ) {
			delete this->p_operand2;
			this->p_operand2 = nullptr;
		}
	}
};

#endif
