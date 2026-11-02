// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_pos.h"

// --------------------------------------------------------------------
//	[B6] POS: CSRLIN の X 座標版。引数はダミー (実機と同じ)。
//	カーソル X 座標 (F3DDh) は 1 始まりなので、0 始まりに直す。
// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_POS::optimization( CCOMPILE_INFO *p_info ) {
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
void CEXPRESSION_POS::compile( CCOMPILE_INFO *p_info ) {
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
	p_info->assembler_list.add_label( "work_csrx", "0x0f3dd" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[work_csrx]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::CONSTANT, "0" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
