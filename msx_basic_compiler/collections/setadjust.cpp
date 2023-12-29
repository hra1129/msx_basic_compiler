// --------------------------------------------------------------------
//	Compiler collection: SetAdjust
// ====================================================================
//	2023/Dec/29th	t.hara
// --------------------------------------------------------------------

#include "setadjust.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SET ADJUST ( X, Y )
//  SET ADJUSTS ( X, Y )
//
bool CSETADJUST::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool is_set_adjust = false;

	if( p_info->list.p_position->s_word != "SET" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->list.p_position--;
		return false;
	}
	else if( p_info->list.p_position->s_word == "ADJUST" ) {
		p_info->list.p_position++;
		is_set_adjust = true;
	}
	else if( p_info->list.p_position->s_word == "ADJUSTS" ) {
		p_info->list.p_position++;
	}
	else {
		p_info->list.p_position--;
		return false;
	}
	p_info->assembler_list.add_label( "blib_setadjust", "0x040cc" );

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ){
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	‘æ1ˆø” X
	if( exp.compile( p_info ) ) {
		exp.release();
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
		return true;
	}

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	‘æ2ˆø” Y
	if( exp.compile( p_info ) ) {
		exp.release();
		asm_line.set( "POP", "", "DE" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
		return true;
	}

	//	ADJUST ‚© ADJUSTS ‚©
	if( is_set_adjust ) {
		//	ADJUST ‚Í RTC ‚Ö‘‚«ž‚Þ
		asm_line.set( "LD", "", "B", "1" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	ADJUST ‚Í RTC ‚Ö‘‚«ž‚Ü‚È‚¢
		asm_line.set( "LD", "", "B", "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( "LD", "", "IX", "blib_setadjust" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, line_no );
		return true;
	}
	p_info->list.p_position++;

	return true;
}
