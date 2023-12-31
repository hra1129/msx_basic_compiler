// --------------------------------------------------------------------
//	Compiler collection: Beep
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "beep.h"

// --------------------------------------------------------------------
//  BEEP �u�U�[
bool CBEEP::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	std::string s_label1, s_label2;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "BEEP" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_beep", "0x00C0" );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_beep", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
