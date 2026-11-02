// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_lpos.h"

// --------------------------------------------------------------------
//	[B6] LPOS: プリンタの桁カウンタ (F415h) を読む。引数はダミー。
//	カウンタは 0 始まり (出力した文字数) なので補正は不要。
// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_LPOS::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_LPOS::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	引数はダミーだが、実機同様に評価だけは行う
	this->p_operand->compile( p_info );
	if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	this->type = CEXPRESSION_TYPE::INTEGER;
	p_info->assembler_list.add_label( "work_lpos", "0x0f415" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[work_lpos]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::CONSTANT, "0" );
	p_info->assembler_list.body.push_back( asm_line );
}
