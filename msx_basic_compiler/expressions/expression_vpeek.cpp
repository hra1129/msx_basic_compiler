// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_vpeek.h"

// --------------------------------------------------------------------
void CEXPRESSION_VPEEK::optimization( CCOMPILE_INFO *p_info ) {
	
	this->p_operand->optimization( p_info );
}

// --------------------------------------------------------------------
void CEXPRESSION_VPEEK::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER, this->p_operand->type );

	if( p_info->options.target_type == CTARGET_TYPES::MSX1 ) {
		p_info->assembler_list.add_label( "bios_rdvrm", "0x004A" );

		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bios_rdvrm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY_REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY_REGISTER, "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->assembler_list.add_label( "bios_nrdvrm", "0x0174" );

		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bios_nrdvrm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY_REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY_REGISTER, "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	this->type = CEXPRESSION_TYPE::INTEGER;
}
