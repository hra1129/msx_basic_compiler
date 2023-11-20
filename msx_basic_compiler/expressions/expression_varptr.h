// --------------------------------------------------------------------
//	Expression VARPTR
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression.h"

#ifndef __EXPRESSION_VARPTR_H__
#define __EXPRESSION_VARPTR_H__

// --------------------------------------------------------------------
//	ä÷êîåƒÇ—èoÇµ
class CEXPRESSION_VARPTR: public CEXPRESSION_NODE {
public:
	bool is_file_type = false;			// false: VARPTR(A), true: VARPTR(#1)
	int file_number = 0;				// #n ÇÃ nÅA0Å`15
	std::vector< CBASIC_WORD >::const_iterator p_position;

	~CEXPRESSION_VARPTR() {
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
