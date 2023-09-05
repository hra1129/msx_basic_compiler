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
void CEXPRESSION_OPERATOR_IMP::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_left->optimization( p_info );
	this->p_right->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_IMP::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_info );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	¶‘¤‚Ì€‚ª®”Œ^‚Å‚È‚¯‚ê‚ÎA®”Œ^‚É•ÏŠ·‚·‚é
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_info->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_info );

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	‰E‘¤‚Ì€‚ª®”Œ^‚Å‚È‚¯‚ê‚ÎA®”Œ^‚É•ÏŠ·‚·‚é
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	‚±‚Ì‰‰ŽZŽq‚ÌŒ‹‰Ê‚Í•K‚¸®”Œ^
	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.type = CMNEMONIC_TYPE::POP;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "DE";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "E";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::CPL;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::OR;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "L";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "L";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "D";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::CPL;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::OR;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "H";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "H";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_info->assembler_list.body.push_back( asm_line );
}
