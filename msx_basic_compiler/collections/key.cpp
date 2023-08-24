// --------------------------------------------------------------------
//	Compiler collection: Key
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "key.h"

// --------------------------------------------------------------------
//  KEY ファンクションキー制御
bool CKEY::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "KEY" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return false;
	}

	if( p_info->list.p_position->s_word == "ON" ) {
		p_info->assembler_list.add_label( "bios_dspfnk", "0x000CF" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_dspfnk", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else if( p_info->list.p_position->s_word == "OFF" ) {
		p_info->assembler_list.add_label( "bios_erafnk", "0x000CC" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_erafnk", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else if( p_info->list.p_position->s_word == "LIST" ) {
		p_info->assembler_list.add_label( "bios_lstfnk", "0x07871" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_lstfnk", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	return true;
}
