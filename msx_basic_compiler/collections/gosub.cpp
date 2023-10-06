// --------------------------------------------------------------------
//	Compiler collection: Gosub
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "gosub.h"

// --------------------------------------------------------------------
//  GOSUB s”Ô†
bool CGOSUB::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "GOSUB" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	GOSUB ‚¾‚¯‚ÅI‚í‚Á‚Ä‚éê‡‚Í Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->list.p_position++;
	return true;
}
