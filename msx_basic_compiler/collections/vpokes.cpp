// --------------------------------------------------------------------
//	Compiler collection: VPokes
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------

#include "vpokes.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  VPOKES <アドレス>, <文字列式>
bool CVPOKES::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "VPOKES" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	//	第1引数 <アドレス>
	if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 <値>
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		p_info->assembler_list.activate_free_string();
		p_info->assembler_list.add_label( "blib_vpokes", "0x0408d" );
		asm_line.set( "POP", "", "DE", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "IX", "blib_vpokes" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "free_string" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	return true;
}
