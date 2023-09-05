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

	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_info );

	p_info->assembler_list.push_hl( this->p_left->type );

	this->p_right->compile( p_info );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚ÌŒ^‚ðŒˆ‚ß‚é
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	else if( this->p_left->type == this->p_right->type ) {
		//	¶‰E‚Ì€‚ª“¯‚¶Œ^‚È‚çA‚»‚ÌŒ^‚ðŒp³
		this->type = this->p_left->type;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	¶‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚Å¶‚ðÌ—p
		this->type = this->p_left->type;
		//	ƒXƒ^ƒbƒN‚É¶€AHL‚É‰E€B‰E€‚ð¶€‚ÌŒ^‚ÉŠiã‚°‚·‚é‚Ì‚Å convert_type ‚ðŒÄ‚Ô‚¾‚¯‚Å‚¢‚¢
		this->convert_type( p_info, this->type, this->p_right->type );
	}
	else {
		//	‰E‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚Å‰E‚ðÌ—p
		this->type = this->p_right->type;
		//	ƒXƒ^ƒbƒN‚É¶€AHL‚É‰E€BHL‚ð•ÛŒì‚µ‚Â‚ÂAƒXƒ^ƒbƒNã‚Ì¶€‚ð•ÏŠ·‚·‚é
		if( this->p_left->type == CEXPRESSION_TYPE::INTEGER ) {
			//	¶€‚ª®”Œ^‚Ìê‡
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
		}
		else {
			//	¶€‚ª’P¸“xŽÀ”Œ^‚Ìê‡










		}
		already_dac_active = true;
	}
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		p_info->assembler_list.add_label( "bios_imult", "0x03193" );
		//	‚±‚Ì‰‰ŽZŽq‚ª®”‚Ìê‡
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
		//	‚±‚Ì‰‰ŽZŽq‚ª’P¸“xŽÀ”‚Ìê‡
		if( !already_dac_active ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_dac", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
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
		//	‚±‚Ì‰‰ŽZŽq‚ª”{¸“xŽÀ”‚Ìê‡
		if( !already_dac_active ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_double_real_dac", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decmul", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
