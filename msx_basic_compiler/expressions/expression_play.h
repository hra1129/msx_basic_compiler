// --------------------------------------------------------------------
//	Expression PLAY
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression.h"

// --------------------------------------------------------------------
//	関数呼び出し
class CEXPRESSION_PLAY: public CEXPRESSION_NODE {
public:
	~CEXPRESSION_PLAY() {
		this->release();
	}
	CEXPRESSION_NODE *p_operand = nullptr;

	CEXPRESSION_NODE* optimization( CCOMPILE_INFO *p_info );

	void compile( CCOMPILE_INFO *p_info );

	void release( void ) {
		delete this->p_operand;
		this->p_operand = nullptr;
	}
};
