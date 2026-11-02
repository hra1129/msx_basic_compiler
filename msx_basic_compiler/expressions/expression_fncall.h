// --------------------------------------------------------------------
//	Expression: DEF FN call (inline expansion)
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include "expression.h"

#ifndef __EXPRESSION_FNCALL_H__
#define __EXPRESSION_FNCALL_H__

class CEXPRESSION_FNCALL: public CEXPRESSION_NODE {
public:
	CEXPRESSION_NODE *p_arg = nullptr;		//	実引数の式
	CEXPRESSION_NODE *p_body = nullptr;		//	定義本体の式 (定義位置の単語列から構築)
	CVARIABLE param;						//	仮引数変数
	CEXPRESSION_TYPE result_type = CEXPRESSION_TYPE::DOUBLE_REAL;

	void release( void ) {
		if( this->p_arg != nullptr ) {
			delete this->p_arg;
			this->p_arg = nullptr;
		}
		if( this->p_body != nullptr ) {
			delete this->p_body;
			this->p_body = nullptr;
		}
	}
	CEXPRESSION_NODE *optimization( CCOMPILE_INFO *p_info );
	void compile( CCOMPILE_INFO *p_info );
};

#endif
