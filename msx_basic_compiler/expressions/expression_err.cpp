// --------------------------------------------------------------------
//	Expression ERR / ERL
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_err.h"

// --------------------------------------------------------------------
//	ERR: 最後に捕捉したエラーコード (ON ERROR のハンドラ内で有効)。
//	ERL: そのエラーが発生した行番号 (ラベル行の場合はその行番号)。
//	どちらも ON ERROR の特殊変数 (error_code / error_line) を読む。
// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_ERR::optimization( CCOMPILE_INFO *p_info ) {
	return nullptr;
}

CEXPRESSION_NODE* CEXPRESSION_ERL::optimization( CCOMPILE_INFO *p_info ) {
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_ERR::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[svarb_error_code]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::CONSTANT, "0" );
	p_info->assembler_list.body.push_back( asm_line );
}

// --------------------------------------------------------------------
void CEXPRESSION_ERL::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[svari_error_line]" );
	p_info->assembler_list.body.push_back( asm_line );
}
