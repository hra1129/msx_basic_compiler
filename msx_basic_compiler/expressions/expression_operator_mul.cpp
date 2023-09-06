// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_mul.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MUL::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_left->optimization( p_info );
	this->p_right->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MUL::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	bool already_dac_active = false;
	bool already_arg_active = false;

	//	��ɍ�������
	this->p_left->compile( p_info );

	p_info->assembler_list.push_hl( this->p_left->type );

	this->p_right->compile( p_info );

	//	���̉��Z�q�̉��Z���ʂ̌^�����߂�
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	else if( this->p_left->type == this->p_right->type ) {
		//	���E�̍��������^�Ȃ�A���̌^���p��
		this->type = this->p_left->type;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	���̕����^���傫���̂ō����̗p
		this->type = this->p_left->type;
		//	�X�^�b�N�ɍ����AHL�ɉE���B�E���������̌^�Ɋi�グ����̂� convert_type ���ĂԂ����ł���
		this->convert_type( p_info, this->type, this->p_right->type );
	}
	else {
		//	�E�̕����^���傫���̂ŉE���̗p
		this->type = this->p_right->type;
		//	�X�^�b�N�ɍ����AHL�ɉE���BHL��ی삵�A�X�^�b�N��̍�����ϊ�����
		if( this->p_left->type == CEXPRESSION_TYPE::INTEGER ) {
			//	�����������^�̏ꍇ
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			this->convert_type( p_info, this->type, CEXPRESSION_TYPE::INTEGER );
			if( this->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
				p_info->assembler_list.activate_ld_arg_single_real();
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				p_info->assembler_list.activate_ld_arg_double_real();
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			already_arg_active = true;
		}
		else {
			//	�������P���x�����^�̏ꍇ�A��ɉE��(�{���x)�� DAC �փR�s�[
			p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
			p_info->assembler_list.activate_ld_arg_double_real();
			p_info->assembler_list.activate_pop_single_real_dac();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			already_dac_active = true;
			already_arg_active = true;
		}
	}
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		p_info->assembler_list.add_label( "bios_imult", "0x03193" );
		//	���̉��Z�q�������̏ꍇ
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_imult", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		p_info->assembler_list.add_label( "bios_decmul", "0x027e6" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
		p_info->assembler_list.activate_ld_arg_single_real();
		p_info->assembler_list.activate_pop_single_real_dac();
		//	���̉��Z�q���P���x�����̏ꍇ
		if( !already_arg_active ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( !already_dac_active ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decmul", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		p_info->assembler_list.add_label( "bios_decmul", "0x027e6" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
		p_info->assembler_list.activate_ld_arg_double_real();
		p_info->assembler_list.activate_pop_double_real_dac();
		//	���̉��Z�q���{���x�����̏ꍇ
		if( !already_arg_active ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( !already_dac_active ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_double_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decmul", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
