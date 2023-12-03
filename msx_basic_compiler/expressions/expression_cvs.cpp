// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/Dec/03rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_term.h"
#include "expression_cvs.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_CVS::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_CVS::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	this->p_operand->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::STRING, this->p_operand->type );
	this->type = CEXPRESSION_TYPE::SINGLE_REAL;

	p_info->assembler_list.activate_free_string();
	p_info->assembler_list.activate_ld_dac_single_real();
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_single_real", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "work_dac" );
	p_info->assembler_list.body.push_back( asm_line );
}
