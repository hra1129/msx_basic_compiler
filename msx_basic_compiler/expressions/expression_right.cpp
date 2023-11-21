// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_right.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_RIGHT::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

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
void CEXPRESSION_RIGHT::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand1->compile( p_info );

	if( this->p_operand1->type == CEXPRESSION_TYPE::STRING ) {
		p_info->assembler_list.activate_copy_string();
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::LABEL, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}

	this->p_operand2->compile( p_info );
	this->p_operand2->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand2->type );
	p_info->assembler_list.add_label( "blib_right", "0x0402d" );

	p_info->assembler_list.activate_free_string();
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::LABEL, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_right" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "DE", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::LABEL, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::LABEL, "DE", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "copy_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::STRING;
}
