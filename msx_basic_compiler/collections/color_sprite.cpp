// --------------------------------------------------------------------
//	Compiler collection: Color sprite
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "color_sprite.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  COLOR SPRITE( <スプライトプレーン番号> ) = <色>
//  COLOR SPRITE$( <スプライトプレーン番号> ) = <色>
bool CCOLOR_SPRITE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	bool is_string;
	int line_no = p_info->list.get_line_no();

	//	COLOR
	if( p_info->list.p_position->s_word != "COLOR" ) {
		return false;
	}
	p_info->list.p_position++;

	//	SPRITE
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "SPRITE" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	//	$
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word == "$" ) {
		p_info->assembler_list.add_label( "blib_colorsprite_str", "0x040a8" );
		p_info->list.p_position++;
		is_string = true;
	}
	else {
		p_info->assembler_list.add_label( "blib_colorsprite", "0x040a5" );
		is_string = false;
	}

	//	(
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	スプライトプレーン番号
	if( exp.compile( p_info ) ) {
		asm_line.set( "PUSH", "", "HL" );
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

	//	=
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "=" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	色
	if( is_string ) {
		if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
			//	色文字列
			p_info->assembler_list.activate_free_string();
			asm_line.set( "POP", "", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "A", "E" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_colorsprite_str" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "free_string" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
	}
	else {
		if( exp.compile( p_info ) ) {
			//	色
			asm_line.set( "POP", "", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "A", "E" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_colorsprite" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
	}
	return true;
}
