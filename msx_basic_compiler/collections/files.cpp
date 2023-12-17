// --------------------------------------------------------------------
//	Compiler collection: Files
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "files.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  FILES "ワイルドカード"
bool CFILES::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	bool has_wildcard = false;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD || p_info->list.p_position->s_word != "FILES" ) {
		return false;
	}
	p_info->list.p_position++;
	p_info->assembler_list.activate_free_string();

	//	第1引数 ワイルドカード
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		asm_line.set( "PUSH", "", "HL", "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_wildcard = true;
	}
	else {
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	p_info->assembler_list.add_label( "blib_files", "0x04099" );
	asm_line.set( "LD", "", "IX", "blib_files" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	if( has_wildcard ) {
		asm_line.set( "POP", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "free_string" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
