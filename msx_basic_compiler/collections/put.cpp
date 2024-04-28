// --------------------------------------------------------------------
//	Compiler collection: Field
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "put.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PUT #n, レコード番号
//
bool CPUT::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "PUT" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "#" ) {
		//	PUT SPRITE 等別の命令かもしれないので、この単語を消費しない。PUT も見なかったことにする。
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.activate_file_number();
	p_info->use_file_access = true;

	//	#n の n
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	exp.release();
	asm_line.set( "CALL", "", "sub_file_number" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );

	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	レコード番号
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	exp.release();
	asm_line.set( "POP", "", "DE" );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->assembler_list.add_label( "blib_put", "0x40fc" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::CONSTANT, "blib_put" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
