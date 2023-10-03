// --------------------------------------------------------------------
//	Compiler collection: Width
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "width.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  WIDTH {•}
bool CWIDTH::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "WIDTH" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	if( exp.compile( p_info ) ) {
		exp.release();
	}
	p_info->assembler_list.add_label( "blib_width", "0x0403c" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "ix", COPERAND_TYPE::LABEL, "blib_width" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
