// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/Dec/03rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_term.h"
#include "expression_mki.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_MKI::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;
	int d;
	std::string s1, s2;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	Ž–‘OŒvŽZˆ—
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		//	’è”‚Ìê‡
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			//	”’l‚Ìê‡
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::STRING;
			d = std::stol( this->p_operand->s_value );
			s1 = (char)(unsigned char)( d & 255 );
			s2 = (char)(unsigned char)( d >> 8 );
			p_term->s_value = s1 + s2;
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_MKI::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	p_info->assembler_list.activate_allocate_string();
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "3" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "allocate_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	this->p_operand->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
	this->type = CEXPRESSION_TYPE::STRING;

	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::REGISTER, "E" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::REGISTER, "D" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
