// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_frnd.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_FRND::optimization( CCOMPILE_INFO *p_info ) {

	return nullptr;
}

// --------------------------------------------------------------------
//	[B6] FRND: 高速版 RND。実体はライブラリ側 sub_frnd で、DAC に
//	[0,1) の倍精度実数を返す。乱数状態は RND/IRND と同じ RNDX を使う。
void CEXPRESSION_FRND::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
	p_info->assembler_list.add_label( "blib_frnd", "0x04132" );
	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	asm_line.set( "LD", "", "IX", "blib_frnd" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
	p_info->assembler_list.body.push_back( asm_line );
}
