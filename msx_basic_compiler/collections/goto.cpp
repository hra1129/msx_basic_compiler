// --------------------------------------------------------------------
//	Compiler collection: Goto
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "goto.h"

// --------------------------------------------------------------------
//  GOTO s”Ô†
bool CGOTO::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "GOTO" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	GOTO ‚¾‚¯‚ÅI‚í‚Á‚Ä‚éê‡‚Í Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	CASSEMBLER_LINE asm_line;
	asm_line.type = CMNEMONIC_TYPE::JP;
	asm_line.operand1.s_value = "line_" + p_info->list.p_position->s_word;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	p_info->assembler_list.body.push_back( asm_line );
	p_info->list.p_position++;
	return true;
}
