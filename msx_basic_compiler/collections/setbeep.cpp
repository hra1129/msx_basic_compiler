// --------------------------------------------------------------------
//	Compiler collection: SetBeep
// ====================================================================
//	2023/Dec/30th	t.hara
// --------------------------------------------------------------------

#include "setbeep.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SETBEEP 音色, 音量
bool CSETBEEP::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool has_type = false;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "BEEP" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "blib_setbeep", "0x040cf" );

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	//	第1引数 音色
	if( exp.compile( p_info ) ) {
		exp.release();
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		has_type = true;
	}
	else {
		has_type = false;
	}
	if( p_info->list.is_command_end() ) {
		if( has_type ) {
			//	SET BEEP <音色> の場合。
			asm_line.set( "POP", "", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", "0" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_setbeep" );
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
		//	SET BEEP <音色> 解釈不能文字 の場合はエラー
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 音量
	if( exp.compile( p_info ) ) {
		exp.release();
		if( has_type ) {
			asm_line.set( "POP", "", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.set( "LD", "", "DE", "0" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( "LD", "", "IX", "blib_setbeep" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	SET BEEP <音色>, 解釈不能文字 の場合はエラー
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
		return true;
	}
	return true;
}
