// --------------------------------------------------------------------
//	Compiler collection: Get
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "get.h"

// --------------------------------------------------------------------
//  GET DATE •¶š—ñ•Ï”–¼ [,A]
//	GET TIME •¶š—ñ•Ï”–¼ [,A]
//
bool CGET::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool is_time = false;

	if( p_info->list.p_position->s_word != "GET" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	GET ‚¾‚¯‚ÅI‚í‚Á‚Ä‚éê‡‚Í Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( p_info->list.p_position->s_word == "TIME" ) {
		is_time = true;
		p_info->list.p_position++;
	}
	else if( p_info->list.p_position->s_word == "DATE" ) {
		is_time = false;
		p_info->list.p_position++;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	p_info->assembler_list.activate_free_string();
	p_info->assembler_list.activate_copy_string();

	CVARIABLE variable = p_info->p_compiler->get_variable_address();
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );

	if( p_info->list.is_command_end() ) {
		asm_line.set( "XOR", "", "A", "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( p_info->list.p_position->s_word == "," ) {
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "A" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( "LD", "", "A", "1" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( is_time ) {
		p_info->assembler_list.add_label( "blib_get_time", "0x040c9" );
		asm_line.set( "LD", "", "IX", "blib_get_time" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->assembler_list.add_label( "blib_get_date", "0x040c6" );
		asm_line.set( "LD", "", "IX", "blib_get_date" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	asm_line.set( "CALL", "", "copy_string" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "DE" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
