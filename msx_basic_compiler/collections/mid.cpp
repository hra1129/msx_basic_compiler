// --------------------------------------------------------------------
//	Compiler collection: Mid$
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "mid.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  MID$( 変数名, 置換開始位置 [, 置換サイズ] ) = 置換文字列
bool CMID::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "MID$" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->list.p_position--;
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	CVARIABLE variable = p_info->p_compiler->get_variable_address();
	if( variable.type != CVARIABLE_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, line_no );
		return true;
	}
	p_info->assembler_list.activate_copy_string_to_buffer();
	p_info->assembler_list.activate_legacy_string_buffer2();
	p_info->assembler_list.activate_copy_string_from_buffer();
	p_info->assembler_list.activate_free_string();
	p_info->assembler_list.activate_assign_string();
	asm_line.set( "PUSH", "", "HL" );						// destination descriptor
	p_info->assembler_list.body.push_back( asm_line );

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( !exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	asm_line.set( "LD", "", "B", "L" );					// replacement position (1-based)
	p_info->assembler_list.body.push_back( asm_line );
	exp.release();

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		asm_line.set( "PUSH", "", "BC" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( "POP", "", "BC" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "C", "L" );					// maximum replacement length
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		asm_line.set( "LD", "", "C", "255" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "=" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	asm_line.set( "PUSH", "", "BC" );						// Preserve MID$ position and length
	p_info->assembler_list.body.push_back( asm_line );
	if( !exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	exp.release();

	// Convert the source first so MID$ can safely replace a substring of itself.
	asm_line.set( "PUSH", "", "HL" );						// source descriptor
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "legacy_string_buffer2" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string_to_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.set( "POP", "", "BC" );						// MID$ position and length
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );						// destination descriptor
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "legacy_string_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string_to_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "BC" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "legacy_string_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "legacy_string_buffer2" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.add_label( "blib_mid_cmd", "0x0406c" );
	asm_line.set( "LD", "", "IX", "blib_mid_cmd" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.set( "LD", "", "HL", "legacy_string_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string_from_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "DE" );						// destination descriptor
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "assign_string" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
