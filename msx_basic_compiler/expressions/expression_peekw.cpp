// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_peekw.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_PEEKW::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	PEEKWŠÖ”‚ÍÅ“K‰»‚ÅÁ–Å‚·‚é‚±‚Æ‚Í‚È‚¢
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_PEEKW::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand->is_constant && this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
		//	ˆø”‚ª’è”‚Ìê‡
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[" + this->p_operand->s_value + "]" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	æ‚Éˆø”‚ðˆ—
		this->p_operand->compile( p_info );
		this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER, this->p_operand->type );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[HL]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY, "[HL]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY, "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	this->type = CEXPRESSION_TYPE::INTEGER;
}
