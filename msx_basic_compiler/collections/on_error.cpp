// --------------------------------------------------------------------
//	Compiler collection: On Error
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------

#include "on_error.h"

// --------------------------------------------------------------------
//  ON ERROR GOTO <行番号>
//  ON ERROR GOTO 0  (解除)
//	エラー捕捉は H.ERRO フック (h_erro_handler) が一括して行う。
//	ここでは飛び先アドレスを特殊変数 error_target へ格納するだけ。
//	CONGOTO より先に判定する必要がある (ERR が式として解釈されるため)。
bool CONERROR::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "ON" ) {
		return false;
	}
	if( (p_info->list.p_position + 1)->s_word != "ERROR" ) {
		return false;
	}
	p_info->list.p_position += 2;
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "GOTO" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->use_on_error = true;
	if( p_info->list.p_position->s_word == "0" ) {
		//	解除
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( p_info->list.p_position->s_word[0] == '*' ) {
		asm_line.set( "LD", "", "HL", "label_" + p_info->list.p_position->s_word.substr(1) );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		asm_line.set( "LD", "", "HL", "line_" + p_info->list.p_position->s_word );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( "LD", "", "[svari_error_target]", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->list.p_position++;
	return true;
}
