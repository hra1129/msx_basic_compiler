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

	if( p_info->list.is_command_end() ) {
		//	BLOAD "ファイル名"
		p_info->assembler_list.activate_bload();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_bload", COPERAND_TYPE::NONE, "" );
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
			if( !is_load && p_info->list.p_position->s_word == "," ) {

			}
			//	BLOAD "ファイル名",R
			p_info->assembler_list.activate_bload_r();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_bload_r", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( !is_load && (p_info->list.p_position->s_word == "S" || p_info->list.p_position->s_word == "s") ) {
			p_info->list.p_position++;
			if( !is_load && p_info->list.p_position->s_word == "," ) {

			}
			//	BLOAD "ファイル名",S
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[heap_end]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY, "[heap_next]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::CONSTANT, "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "H" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->assembler_list.add_label( "blib_bload_s", "0x04057" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::CONSTANT, "blib_bload_s" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( exp.compile( p_info ) ) {

		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	return true;
}
