// --------------------------------------------------------------------
//	Compiler collection: Return
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "return.h"

// --------------------------------------------------------------------
//  RETURN
bool CRETURN::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "RETURN" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_line_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
		//	RETURN だけで終わってる場合は RET だけ。
		asm_line.type = CMNEMONIC_TYPE::RET;
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	行番号が続いてる場合は、戻り番地を捨てて指定の行にジャンプする。
		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.type = CMNEMONIC_TYPE::JP;
		asm_line.operand1.s_value = "line_" + p_info->list.p_position->s_word;
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
