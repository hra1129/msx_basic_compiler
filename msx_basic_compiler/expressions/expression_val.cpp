// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_val.h"

// --------------------------------------------------------------------
void CEXPRESSION_VAL::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_VAL::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "VALの引数", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	//	先に引数を処理
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}

	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "VALの本体開始", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->assembler_list.add_label( "bios_fin", "0x3299" );
	p_info->assembler_list.add_label( "bios_frcdbl", "0x303a" );
	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	p_info->assembler_list.activate_free_string();

	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_fin", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "work_dac" );
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "VALの本体終了", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
}
