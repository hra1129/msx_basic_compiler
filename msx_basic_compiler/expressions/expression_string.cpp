// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_string.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_STRING::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand1 == nullptr || this->p_operand2 == nullptr ) {
		return nullptr;
	}
	p = this->p_operand1->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand1;
		this->p_operand1 = p;
	}
	p = this->p_operand2->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand2;
		this->p_operand2 = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_STRING::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand1 == nullptr || this->p_operand2 == nullptr ) {
		return;
	}
	//	‘æ‚Pˆø”‚ðˆ—
	this->p_operand1->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand1->type );
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );

	//	‘æ‚Qˆø”‚ðˆ—
	this->p_operand2->compile( p_info );
	p_info->assembler_list.activate_string();
	if( this->p_operand2->type == CEXPRESSION_TYPE::STRING ) {
		asm_line.set( "POP", "", "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "string" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand2->type );
		asm_line.set( "LD", "", "A", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "string_a" );
		p_info->assembler_list.body.push_back( asm_line );
	}


	this->type = CEXPRESSION_TYPE::STRING;
}
