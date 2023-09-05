// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_div.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_DIV::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_left->optimization( p_info );
	this->p_right->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_DIV::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_info );
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚ÌŒ^‚ðŒˆ‚ß‚é
	this->type_adjust_2op( p_info, this->p_left, this->p_right );
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	®”‚Ìê‡
		p_info->assembler_list.add_label( "bios_idiv", "0x031e6" );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_idiv", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::STRING ) {
	}
	else {
		//	ŽÀ”‚Ìê‡
		p_info->assembler_list.add_label( "bios_decdiv", "0x0289f" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decdiv", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
