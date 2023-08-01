// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "compiler.h"

// --------------------------------------------------------------------
class CEXPRESSION_NODE {
public:

	// ----------------------------------------------------------------
	//	���Z���c���[�̒��Ŏ��O�ɉ��Z�\�ȃ��m�͉��Z���Ă��܂�
	virtual void optimization( void ) = 0;
};

// --------------------------------------------------------------------
class CEXPRESSION {
private:
	// ----------------------------------------------------------------
	//	���Z���c���[�̎���
	CEXPRESSION_NODE *p_top_node;

	// ----------------------------------------------------------------
	//	���Z���c���[�̒��Ŏ��O�ɉ��Z�\�ȃ��m�͉��Z���Ă��܂�
	void optimization( void );

	// ----------------------------------------------------------------
	CEXPRESSION_NODE *makeup_node_brackets( CCOMPILER *p_this );					//	( ) ����
	CEXPRESSION_NODE *makeup_node_term( CCOMPILER *p_this );					//	�֐�, FN�֐�
	CEXPRESSION_NODE *makeup_node_operator_power( CCOMPILER *p_this );				//	^ �ݏ�
	CEXPRESSION_NODE *makeup_node_operator_minus_plus( CCOMPILER *p_this );			//	- + ����
	CEXPRESSION_NODE *makeup_node_operator_mul_div( CCOMPILER *p_this );			//	* / ��Z�A���Z
	CEXPRESSION_NODE *makeup_node_operator_intdiv( CCOMPILER *p_this );				//	�� �������Z
	CEXPRESSION_NODE *makeup_node_operator_mod( CCOMPILER *p_this );				//	MOD �]��
	CEXPRESSION_NODE *makeup_node_operator_add_sub( CCOMPILER *p_this );			//	+ - �����Z
	CEXPRESSION_NODE *makeup_node_operator_compare( CCOMPILER *p_this );			//	= <> >< < <= =< > >= => ��r
	CEXPRESSION_NODE *makeup_node_operator_not( CCOMPILER *p_this );				//	NOT ���]
	CEXPRESSION_NODE *makeup_node_operator_and( CCOMPILER *p_this );				//	AND �_����
	CEXPRESSION_NODE *makeup_node_operator_or( CCOMPILER *p_this );					//	OR �_���a
	CEXPRESSION_NODE *makeup_node_operator_xor( CCOMPILER *p_this );				//	XOR �r���I�_���a
	CEXPRESSION_NODE *makeup_node_operator_imp( CCOMPILER *p_this );				//	IMP ���
	CEXPRESSION_NODE *makeup_node_operator_eqv( CCOMPILER *p_this );				//	EQV ���l
public:
	// ----------------------------------------------------------------
	//	�\�[�X�R�[�h�����߂��āA���Z���c���[���`������
	void makeup_node( CCOMPILER *p_this );

	// ----------------------------------------------------------------
	//	���Z���c���[����A�Z���u���R�[�h�𐶐�����
	void compile( CCOMPILER *p_this );
};
