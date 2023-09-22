// --------------------------------------------------------------------
//	Compiler collection: Erase
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "erase.h"

// --------------------------------------------------------------------
//  ERASE ”z—ñíœ
bool CERASE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "ERASE" ) {
		return false;
	}
	p_info->list.p_position++;

	for(;;) {
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		variable = p_info->variable_manager.get_array_info( p_info );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + variable.s_label + "]" );
		p_info->assembler_list.body.push_back( asm_line );

		if( variable.type == CVARIABLE_TYPE::STRING ) {
			p_info->assembler_list.activate_free_sarray();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_sarray", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			p_info->assembler_list.activate_free_array();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_array", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[" + variable.s_label + "]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );

		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}
	return true;
}
