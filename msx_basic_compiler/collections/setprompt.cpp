// --------------------------------------------------------------------
//	Compiler collection: SetPrompt
// ====================================================================
//	2023/Dec/30th	t.hara
// --------------------------------------------------------------------

#include "setprompt.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SETPROMPT プロンプト
bool CSETPROMPT::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "PROMPT" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "blib_setprompt", "0x040d2" );
	p_info->assembler_list.activate_free_string();

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	//	第1引数 プロンプト
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
	}
	else {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	asm_line.set( "LD", "", "IX", "blib_setprompt" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
