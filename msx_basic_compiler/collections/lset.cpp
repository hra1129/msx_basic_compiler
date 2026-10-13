// --------------------------------------------------------------------
//	Compiler collection: Lset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "lset.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LSET] {変数名}[(配列要素, 配列要素 ...)] = 式
bool CLSET::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool is_rset;

	if( p_info->list.p_position->s_word != "LSET" && p_info->list.p_position->s_word != "RSET" ) {
		return false;
	}
	is_rset = ( p_info->list.p_position->s_word == "RSET" );
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
	if( p_info->assembler_list.add_subroutines( "legacy_lset_destination" ) ) {
		asm_line.set( "LABEL", "", "legacy_lset_destination" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		asm_line.set( "DEFW", "", "legacy_string_buffer" );
		p_info->assembler_list.variables_area.push_back( asm_line );
	}
	asm_line.set( "PUSH", "", "HL" );						// destination descriptor
	p_info->assembler_list.body.push_back( asm_line );

	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		return true;
	}
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( !exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	exp.release();

	// Preserve the source while bridging it to the legacy BASIC string ABI.
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

	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "legacy_string_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string_to_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "legacy_lset_destination" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "legacy_string_buffer2" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.add_label( is_rset ? "blib_rset" : "blib_lset", is_rset ? "0x04078" : "0x04075" );
	asm_line.set( "LD", "", "IX", is_rset ? "blib_rset" : "blib_lset" );
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
