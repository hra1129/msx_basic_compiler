// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_imp.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_IMP::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_IMP::compile( CCOMPILE_INFO *p_this ) {

	//	��ɍ�������
	this->p_left->compile( p_this );
	this->p_right->compile( p_this );

	//	���̉��Z�q�̉��Z���ʂ̌^�����߂�
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	else if( this->p_left->type == this->p_right->type ) {
		//	���E�̍��������^�Ȃ�A���̌^���p��
		this->type = this->p_left->type;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	���̕����^���傫���̂ō����̗p
		this->type = this->p_left->type;
	}
	else {
		//	�E�̕����^���傫���̂ŉE���̗p
		this->type = this->p_right->type;
	}
}
