// --------------------------------------------------------------------
//	Compiler collection: Play
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------

#include "play.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PLAY [<ch1>], [<ch2>], [<ch3>]
bool CPLAY::exec( CCOMPILE_INFO *p_info ) {
	if( p_info->list.p_position->s_word != "PLAY" ) {
		return false;
	}
	int line_no = p_info->list.get_line_no();
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	p_info->assembler_list.add_label( "blib_play", "0x040FF" );
	p_info->assembler_list.activate_copy_string_to_buffer();
	p_info->assembler_list.activate_free_string();
	if( p_info->assembler_list.add_subroutines( "play_workspace" ) ) {
		asm_line.set( "LABEL", "", "play_workspace" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		// Parser state includes a bounded stack for nested X macros.
		for( int i = 0; i < 3 * 384 / 2; i++ ) {
			asm_line.set( "DEFW", "", "0" );
			p_info->assembler_list.variables_area.push_back( asm_line );
		}
	}
	asm_line.set( "XOR", "", "A", "A" );
	p_info->assembler_list.body.push_back( asm_line );
	for( int channel = 0; channel < 3; channel++ ) {
		asm_line.set( "LD", "", "[play_workspace + " + std::to_string( channel * 384 + 128 ) + "]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	for( int channel = 0; channel < 3; channel++ ) {
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word != "," ) {
			if( !exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
			exp.release();
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "play_workspace + " + std::to_string( channel * 384 + 128 ) );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "copy_string_to_buffer" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "free_string" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( channel == 2 || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}
	asm_line.set( "LD", "", "HL", "play_workspace" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "play_variable_table" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "play_default_types" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "IX", "blib_play" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
