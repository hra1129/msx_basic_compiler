// --------------------------------------------------------------------
//	Compiler collection: Kill
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "kill.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  KILL "ワイルドカード"
bool CKILL::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD || p_info->list.p_position->s_word != "KILL" ) {
		return false;
	}
	p_info->list.p_position++;
	p_info->assembler_list.activate_free_string();

	//	第1引数 ワイルドカード
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		asm_line.set( "PUSH", "", "HL", "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	p_info->assembler_list.add_label( "blib_kill", "0x0409f" );
	asm_line.set( "LD", "", "IX", "blib_kill" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
