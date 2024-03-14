// --------------------------------------------------------------------
//	Compiler collection: Bload
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "bload.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  BLOAD "ファイル名" [,S]
bool CBLOAD::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	bool is_load = false;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD || ( p_info->list.p_position->s_word != "BLOAD" && p_info->list.p_position->s_word != "LOAD" ) ) {
		return false;
	}

	if( p_info->list.p_position->s_word == "LOAD" ) {
		is_load = true;
	}

	p_info->list.p_position++;

	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
	}

	p_info->assembler_list.add_label( "work_buf", "0x0F55E" );
	if( p_info->list.is_command_end() ) {
		//	BLOAD "ファイル名"
		p_info->assembler_list.activate_bload();
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_buf]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "sub_bload" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}

	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "R" || p_info->list.p_position->s_word == "r" ) {
			p_info->list.p_position++;
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			if( !is_load && p_info->list.p_position->s_word == "," ) {
				p_info->list.p_position++;
				//	BLOAD "ファイル名",R,オフセット
				if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
					exp.release();
				}
				else {
					p_info->errors.add( SYNTAX_ERROR, line_no );
					return true;
				}
			}
			else {
				//	BLOAD "ファイル名",R
				asm_line.set( "LD", "", "HL", "0" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			p_info->assembler_list.activate_bload_r();
			asm_line.set( "LD", "", "[work_buf]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "sub_bload_r" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( !is_load && (p_info->list.p_position->s_word == "S" || p_info->list.p_position->s_word == "s") ) {
			p_info->assembler_list.add_label( "work_buf", "0x0F55E" );
			p_info->assembler_list.add_label( "blib_bload_s", "0x04057" );
			p_info->list.p_position++;
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			if( !is_load && p_info->list.p_position->s_word == "," ) {
				p_info->list.p_position++;
				//	BLOAD "ファイル名",S,オフセット
				if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
					exp.release();
				}
				else {
					p_info->errors.add( SYNTAX_ERROR, line_no );
					return true;
				}
			}
			else {
				//	BLOAD "ファイル名",S
				asm_line.set( "LD", "", "HL", "0" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			asm_line.set( "LD", "", "[work_buf]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", "[heap_end]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "[heap_next]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "OR", "", "A", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "SBC", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "C", "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "B", "H" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_bload_s" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			if( exp.compile( p_info ) ) {
				exp.release();
				//	BLOAD "ファイル名", オフセット
				p_info->assembler_list.activate_bload();
				asm_line.set( "LD", "", "[work_buf]", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "sub_bload" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
		}
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	return true;
}
