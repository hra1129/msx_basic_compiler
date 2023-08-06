// --------------------------------------------------------------------
//	Compiler collection: Gosub
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "gosub.h"

// --------------------------------------------------------------------
//  GOSUB s”Ô†
bool CGOSUB::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "GOSUB" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_line_end() ) {
		//	GOSUB ‚¾‚¯‚ÅI‚í‚Á‚Ä‚éê‡‚Í Syntax error.
		p_info->errors.add( "Syntax error.", line_no );
		return true;
	}

	CASSEMBLER_LINE asm_line;
	asm_line.type = CMNEMONIC_TYPE::CALL;
	asm_line.operand1.s_value = "line_" + p_info->list.p_position->s_word;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
