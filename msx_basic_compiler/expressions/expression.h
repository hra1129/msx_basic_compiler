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
	//	���̎��̌^
	CEXPRESSION_TYPE type;

	// ----------------------------------------------------------------
	//	���̎��͒萔���B�萔�ł���΁As_value �ɂ��̒l�B
	bool is_constant;
	std::string s_value;

	// ----------------------------------------------------------------
	//	�R���X�g���N�^
	CEXPRESSION_NODE() {
		this->type = CEXPRESSION_TYPE::UNKNOWN;
		this->is_constant = false;
	}

	// ----------------------------------------------------------------
	//	���
	virtual void release( void ) {
	}

	// ----------------------------------------------------------------
	//	�f�X�g���N�^
	virtual ~CEXPRESSION_NODE() {
		this->release();
	}

	// ----------------------------------------------------------------
	//	�R���p�C�����̌^�ϊ�����
	void convert_type( CCOMPILE_INFO *p_this, CEXPRESSION_TYPE target, CEXPRESSION_TYPE current );

	// ----------------------------------------------------------------
	//	���Z�q�̃I�y�����h�̌^����(2�����Z�q�p)
	void type_adjust_2op( CCOMPILE_INFO *p_this, CEXPRESSION_NODE *p_left, CEXPRESSION_NODE *p_right );

	// ----------------------------------------------------------------
	//	�R���p�C������
	virtual void compile( CCOMPILE_INFO *p_this ) = 0;

	// ----------------------------------------------------------------
	//	���Z���c���[�̒��Ŏ��O�ɉ��Z�\�ȃ��m�͉��Z���Ă��܂�
	virtual void optimization( CCOMPILE_INFO *p_this ) = 0;
};

// --------------------------------------------------------------------
class CEXPRESSION {
private:
	// ----------------------------------------------------------------
	//	���Z���c���[�̎���
	CEXPRESSION_NODE *p_top_node;

	// ----------------------------------------------------------------
	//	�����w��̒P��Ŗ�����Ύw��̃G���[�ɂ���
	bool check_word( CCOMPILE_INFO *p_this, std::string s, CERROR_ID error_id = SYNTAX_ERROR );

	// ----------------------------------------------------------------
	//	���Z���c���[�̒��Ŏ��O�ɉ��Z�\�ȃ��m�͉��Z���Ă��܂�
	void optimization( void );

	// ----------------------------------------------------------------
	//	���Z�q�̃m�[�h��������
	CEXPRESSION_NODE *makeup_node_term( CCOMPILE_INFO *p_this );						//	�֐�, FN�֐�, ( ) ����
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
	//	�R���X�g���N�^
	CEXPRESSION() {
		this->p_top_node = nullptr;
	}

	// ----------------------------------------------------------------
	//	�f�X�g���N�^
	~CEXPRESSION() {
		this->release();
	}

	// ----------------------------------------------------------------
	//	���
	void release( void ) {
		if( this->p_top_node != nullptr ) {
			delete (this->p_top_node);
			this->p_top_node = nullptr;
		}
	}

	// ----------------------------------------------------------------
	//	�\�[�X�R�[�h�����߂��āA���Z���c���[���`������
	void makeup_node( CCOMPILE_INFO *p_this );

	// ----------------------------------------------------------------
	//	���Z���c���[����A�Z���u���R�[�h�𐶐�����
	//	�����ȗ�����Ă����ꍇ�́Afalse ��Ԃ�
	bool compile( CCOMPILE_INFO *p_this, CEXPRESSION_TYPE target = CEXPRESSION_TYPE::INTEGER );

	// ----------------------------------------------------------------
	//	���Z���ʂ̌^��Ԃ�
	CEXPRESSION_TYPE get_type( void ) const {
		if( this->p_top_node == nullptr ) {
			return CEXPRESSION_TYPE::UNKNOWN;
		}
		return this->p_top_node->type;
	}

	// ----------------------------------------------------------------
	void convert_type( CCOMPILE_INFO *p_this, CEXPRESSION_TYPE target ) {
		this->p_top_node->convert_type( p_this, target, this->get_type() );
	}
};

#endif
