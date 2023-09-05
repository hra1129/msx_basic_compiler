// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_variable.h"

// --------------------------------------------------------------------
void CEXPRESSION_VARIABLE::optimization( CCOMPILE_INFO *p_info ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_VARIABLE::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->variable.type == CVARIABLE_TYPE::UNKNOWN ) {
		this->type = CEXPRESSION_TYPE::UNKNOWN;
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	}
	else if( this->variable.type == CVARIABLE_TYPE::INTEGER ) {
		this->type = CEXPRESSION_TYPE::INTEGER;
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + this->variable.s_label + "]" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->variable.type == CVARIABLE_TYPE::STRING ) {
		p_info->assembler_list.activate_copy_string();
		this->type = CEXPRESSION_TYPE::STRING;
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + this->variable.s_label + "]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "copy_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		if( this->variable.type == CVARIABLE_TYPE::SINGLE_REAL ) {
			this->type = CEXPRESSION_TYPE::SINGLE_REAL;
		}
		else {
			this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
		}
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, this->variable.s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
