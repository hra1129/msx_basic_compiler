// --------------------------------------------------------------------
//	Compiler collection: FRandomize
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "frandomize.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  FRANDOMIZE <シード値>
bool CFRANDOMIZE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;

	if( p_info->list.p_position->s_word != "FRANDOMIZE" ) {
		return false;
	}
	p_info->list.p_position++;
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		exp.release();
	}
	else {
		//	FRANDOMIZE だけで終わってる場合は TIME をシードとして使う
		p_info->assembler_list.add_label( "work_jiffy", "0x0fc9e" );
		asm_line.set( "LD", "", "HL", "[work_jiffy]" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	p_info->assembler_list.add_label( "blib_frandomize", "0x04084" );
	asm_line.set( "LD", "", "IX", "blib_frandomize" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
