// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_variable.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_VARIABLE::optimization( CCOMPILE_INFO *p_info ) {
	
	//	配列変数の最適化は、makeup の時点で実施済みなのでここでは何もしない
	return nullptr;
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
		if( this->variable.dimension ) {
			//	配列変数の場合
			p_info->variable_manager.compile_array_elements( p_info, this->exp_list, this->variable );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			//	単独変数の場合
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + this->variable.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else if( this->variable.type == CVARIABLE_TYPE::STRING ) {
		p_info->assembler_list.activate_copy_string();
		this->type = CEXPRESSION_TYPE::STRING;
		if( this->variable.dimension ) {
			//	配列変数の場合
			p_info->variable_manager.compile_array_elements( p_info, this->exp_list, this->variable );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			//	単独変数の場合
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + this->variable.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
		}
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
		if( this->variable.dimension ) {
			//	配列変数の場合
			p_info->variable_manager.compile_array_elements( p_info, this->exp_list, this->variable );
		}
		else {
			//	単独変数の場合
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, this->variable.s_label );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
}
