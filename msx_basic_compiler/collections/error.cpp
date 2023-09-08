// --------------------------------------------------------------------
//	Compiler collection: Sound
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "error.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  ERROR <エラー番号>
bool CERROR::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "ERROR" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	//	第1引数 <エラー番号>
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "bios_errhand", "0x0406F" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_errhand", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
	}
	return true;
}
