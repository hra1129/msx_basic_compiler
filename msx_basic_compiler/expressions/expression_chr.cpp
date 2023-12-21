// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_chr.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_CHR::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;
	int c;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		//	’è”‚Ìê‡
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			CEXPRESSION_TERM *p_operand = reinterpret_cast<CEXPRESSION_TERM*>(this->p_operand);
			c = (int) p_operand->get_value();
			p_term->type = CEXPRESSION_TYPE::STRING;
			p_term->s_value = (char) c;
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_CHR::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	p_info->assembler_list.activate_allocate_string();
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "1" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "allocate_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::STRING;
}
