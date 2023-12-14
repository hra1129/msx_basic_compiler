// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_instr.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_INSTR::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

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
void CEXPRESSION_INSTR::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand1 == nullptr || this->p_operand2 == nullptr ) {
		return;
	}
	//	‘æ‚Pˆø”‚ðˆ—
	this->p_operand1->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::STRING, this->p_operand1->type );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	//	‘æ‚Qˆø”‚ðˆ—
	this->p_operand2->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::STRING, this->p_operand2->type );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->assembler_list.activate_copy_string();
	this->type = CEXPRESSION_TYPE::INTEGER;
	p_info->assembler_list.add_label( "blib_instr", "0x04051" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_instr" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
