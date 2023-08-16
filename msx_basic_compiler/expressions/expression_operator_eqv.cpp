// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_eqv.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_EQV::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_EQV::compile( CCOMPILE_INFO *p_this ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_this );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	¶‘¤‚Ì€‚ª®”Œ^‚Å‚È‚¯‚ê‚ÎA®”Œ^‚É•ÏŠ·‚·‚é
		this->convert_type( p_this, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_this->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_this );

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	‰E‘¤‚Ì€‚ª®”Œ^‚Å‚È‚¯‚ê‚ÎA®”Œ^‚É•ÏŠ·‚·‚é
		this->convert_type( p_this, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	‚±‚Ì‰‰ŽZŽq‚ÌŒ‹‰Ê‚Í•K‚¸®”Œ^
	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "E" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CPL, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "D" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CPL, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_this->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );
	p_this->assembler_list.body.push_back( asm_line );
}
