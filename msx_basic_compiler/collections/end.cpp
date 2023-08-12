// --------------------------------------------------------------------
//	Compiler collection: End
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "end.h"

// --------------------------------------------------------------------
//  END I—¹
bool CEND::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "END" ) {
		return false;
	}
	p_info->list.p_position++;

	CASSEMBLER_LINE asm_line;
	asm_line.type = CMNEMONIC_TYPE::JP;
	asm_line.operand1.s_value = "program_termination";
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
