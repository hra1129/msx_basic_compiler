// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_gt.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_GT::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_left->optimization( p_info );
	this->p_right->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_GT::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION_TYPE compare_type;

	//	êÊÇ…çÄÇèàóù
	this->p_left->compile( p_info );

	p_info->assembler_list.push_hl( this->p_left->type );

	this->p_right->compile( p_info );

	//	Ç±ÇÃââéZéqÇÃââéZåãâ ÇÕïKÇ∏êÆêî
	this->type = CEXPRESSION_TYPE::INTEGER;
	if( this->p_left->type != this->p_right->type && (this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING) ) {
		//	ç∂âEÇÃçÄÇ™àŸÇ»ÇÈå^Ç≈ÅAï–ï˚Ç™ï∂éöóÒå^Ç»ÇÁÉGÉâÅ[
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	ç∂ÇÃï˚Ç™å^Ç™ëÂÇ´Ç¢ÇÃÇ≈ÅAâEÇÃï˚ÇÃå^Çç∂çÄÇ…çáÇÌÇπÇÈ
		compare_type = this->p_left->type;
	}
	else {
		//	âEÇÃï˚Ç™å^Ç™ëÂÇ´Ç¢ÇÃÇ≈ÅAç∂ÇÃï˚ÇÃå^ÇâEçÄÇ…çáÇÌÇπÇÈ
		compare_type = this->p_right->type;
	}
	if( compare_type == CEXPRESSION_TYPE::INTEGER ) {
		//	Ç±ÇÃââéZéqÇ™êÆêîÇÃèÍçá
		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "DE";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::XOR;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::SBC;					//	HL(âEçÄ) < DE(ç∂çÄ) Ç™ê¨óßÇ∑ÇÈèÍçáÇÕ Cy=1, ÇµÇ»Ç¢èÍçáÇÕ Cy=0
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "HL";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "DE";
		p_info->assembler_list.body.push_back( asm_line );

		std::string s_label = p_info->get_auto_label();
		asm_line.type = CMNEMONIC_TYPE::JR;
		asm_line.condition = CCONDITION::NC;
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		asm_line.operand1.s_value = s_label;
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::DEC;
		asm_line.condition = CCONDITION::NONE;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LABEL;
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		asm_line.operand1.s_value = s_label;
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;						//	HL = 0 Ç‹ÇΩÇÕ HL = -1
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "H";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand1.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		p_info->assembler_list.body.push_back( asm_line );
	}
}
