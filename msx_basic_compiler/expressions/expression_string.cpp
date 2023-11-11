// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_string.h"

// --------------------------------------------------------------------
void CEXPRESSION_STRING::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand1->optimization( p_info );
	this->p_operand2->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_STRING::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	‘æ‚Pˆø”‚ðˆ—
	this->p_operand1->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand1->type );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	//	‘æ‚Qˆø”‚ðˆ—
	this->p_operand2->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::STRING, this->p_operand2->type );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->assembler_list.activate_string();
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	this->type = CEXPRESSION_TYPE::STRING;
}
