// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "../compile_info.h"

#ifndef __EXPRESSION_H__
#define __EXPRESSION_H__

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
	CEXPRESSION_NODE *makeup_node_brackets( CCOMPILE_INFO *p_this );					//	( ) ����
	CEXPRESSION_NODE *makeup_node_term( CCOMPILE_INFO *p_this );						//	�֐�, FN�֐�
	CEXPRESSION_NODE *makeup_node_operator_power( CCOMPILE_INFO *p_this );				//	^ �ݏ�
	CEXPRESSION_NODE *makeup_node_operator_minus_plus( CCOMPILE_INFO *p_this );			//	- + ����
	CEXPRESSION_NODE *makeup_node_operator_mul_div( CCOMPILE_INFO *p_this );			//	* / ��Z�A���Z
	CEXPRESSION_NODE *makeup_node_operator_intdiv( CCOMPILE_INFO *p_this );				//	�� �������Z
	CEXPRESSION_NODE *makeup_node_operator_mod( CCOMPILE_INFO *p_this );				//	MOD �]��
	CEXPRESSION_NODE *makeup_node_operator_add_sub( CCOMPILE_INFO *p_this );			//	+ - �����Z
	CEXPRESSION_NODE *makeup_node_operator_compare( CCOMPILE_INFO *p_this );			//	= <> >< < <= =< > >= => ��r
	CEXPRESSION_NODE *makeup_node_operator_not( CCOMPILE_INFO *p_this );				//	NOT ���]
	CEXPRESSION_NODE *makeup_node_operator_and( CCOMPILE_INFO *p_this );				//	AND �_����
	CEXPRESSION_NODE *makeup_node_operator_or( CCOMPILE_INFO *p_this );					//	OR �_���a
	CEXPRESSION_NODE *makeup_node_operator_xor( CCOMPILE_INFO *p_this );				//	XOR �r���I�_���a
	CEXPRESSION_NODE *makeup_node_operator_imp( CCOMPILE_INFO *p_this );				//	IMP ���
	CEXPRESSION_NODE *makeup_node_operator_eqv( CCOMPILE_INFO *p_this );				//	EQV ���l
public:
	// ----------------------------------------------------------------
	//	�\�[�X�R�[�h�����߂��āA���Z���c���[���`������
	void makeup_node( CCOMPILE_INFO *p_this );

	// ----------------------------------------------------------------
	//	���Z���c���[����A�Z���u���R�[�h�𐶐�����
	void compile( CCOMPILE_INFO *p_this );
};

#endif
