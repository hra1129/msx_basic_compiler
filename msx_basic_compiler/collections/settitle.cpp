// --------------------------------------------------------------------
//	Compiler collection: SetTitle
// ====================================================================
//	2023/Dec/30th	t.hara
// --------------------------------------------------------------------

#include "settitle.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SETTITLE タイトル [, 色]
bool CSETTITLE::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool has_title = false;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TITLE" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "blib_settitle", "0x040d5" );
	p_info->assembler_list.activate_free_string();

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	//	第1引数 タイトル
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		has_title = true;
	}
	else {
		has_title = false;
	}
	if( p_info->list.is_command_end() ) {
		if( has_title ) {
			//	SET TITLE <タイトル> の場合。
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "0" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_settitle" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
		else {
			//	引数が何も指定されていない場合はエラー
			p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
			return true;
		}
	}
	//	,
	if( p_info->list.p_position->s_word != "," ) {
		//	SET TITLE 解釈不能文字 の場合はエラー
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 色
	if( exp.compile( p_info ) ) {
		exp.release();
		if( has_title ) {
			asm_line.set( "POP", "", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.set( "LD", "", "DE", "str_0" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "IX", "blib_settitle" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
		if( has_title ) {
			asm_line.set( "CALL", "", "free_string" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else {
		//	SET BEEP <音色>, 解釈不能文字 の場合はエラー
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
		return true;
	}
	return true;
}
