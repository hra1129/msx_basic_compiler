// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_val.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_VAL::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_VAL::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}

	p_info->assembler_list.add_label( "bios_fin", "0x3299" );
	p_info->assembler_list.add_label( "bios_frcdbl", "0x303a" );
	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	p_info->assembler_list.activate_val();
	p_info->assembler_list.activate_free_string();

	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "sub_val" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcdbl", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "work_dac" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
}
