// --------------------------------------------------------------------
//	Compiler collection: Cls
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "cls.h"

// --------------------------------------------------------------------
//  CLS ‰æ–ÊÁ‹
bool CCLS::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "CLS" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_cls", "0x000C3" );
	CASSEMBLER_LINE asm_line;
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_cls", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
