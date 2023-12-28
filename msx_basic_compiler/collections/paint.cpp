// --------------------------------------------------------------------
//	Compiler collection: Paint
// ====================================================================
//	2023/Dec/29th	t.hara
// --------------------------------------------------------------------

#include "paint.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PAINT (X,Y),C,B
bool CPAINT::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();
	bool has_comma_without_c = false;

	if( p_info->list.p_position->s_word != "PAINT" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	p_info->assembler_list.activate_paint();

	//	(
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	X
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_gxpos]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}

	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	Y
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_gypos]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}

	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	,
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	C
		if( exp.compile( p_info ) ) {
			asm_line.set( "LD", "", "A", "L" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			//	C が省略されている場合
			asm_line.set( "LD", "", "A", "[work_forclr]" );
			p_info->assembler_list.body.push_back( asm_line );
			has_comma_without_c = true;
		}
	}
	else {
		//	C が省略されている場合
		asm_line.set( "LD", "", "A", "[work_forclr]" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	C をセット
	asm_line.set( "CALL", "", "bios_setatr" );
	p_info->assembler_list.body.push_back( asm_line );
	//	,
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	B
		if( exp.compile( p_info ) ) {
			//	PAINT (X,Y),C,B または PAINT (X,Y),,B の場合
			asm_line.set( "LD", "", "A", "L" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			//	B が省略されている場合 PAINT (X,Y),C, か PAINT (X,Y),, の場合
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
	}
	else {
		//	B が省略されている場合
		if( has_comma_without_c ) {
			//	, だけあって C も B も省略されている場合はエラー PAINT (X,Y), の場合
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		else {
			//	PAINT (X,Y) の場合
			asm_line.set( "LD", "", "A", "[work_atrbyt]" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	asm_line.set( "CALL", "", "sub_paint" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
