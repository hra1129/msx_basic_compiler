// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_mod.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MOD::optimization( CCOMPILE_INFO *p_info ) {
	
	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	this->p_left->optimization( p_info );
	this->p_right->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MOD::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	��ɍ�������
	this->p_left->compile( p_info );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	�����̍��������^�łȂ���΁A�����^�ɕϊ�����
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_info->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_info );

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	�E���̍��������^�łȂ���΁A�����^�ɕϊ�����
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	���̉��Z�q�̌��ʂ͕K�������^
	this->type = CEXPRESSION_TYPE::INTEGER;
	p_info->assembler_list.add_label( "bios_imod", "0x0323a" );

	//	���̉��Z�q�������̏ꍇ
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_imod", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
