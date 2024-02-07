// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_power.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_POWER::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return nullptr;
	}
	p = this->p_left->optimization( p_info );
	if( p != nullptr ) {
		delete (this->p_left);
		this->p_left = p;
	}

	p = this->p_right->optimization( p_info );
	if( p != nullptr ) {
		delete (this->p_right);
		this->p_right = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_POWER::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_info );						//	Šî”
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );						//	Žw”

	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚ÌŒ^‚ÍA•K‚¸”{¸“x
	this->type_adjust_2op( p_info, this->p_left, this->p_right );

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	®”Œ^‚Ìê‡
		p_info->assembler_list.add_label( "bios_intexp", "0x0383f" );
		p_info->assembler_list.add_label( "bios_frcdbl", "0x0303A" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );

		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_intexp", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	ŽÀ”‚Ìê‡A”{¸“x‚É¸Ši
		p_info->assembler_list.add_label( "bios_dblexp", "0x037d7" );
		p_info->assembler_list.add_label( "bios_frcdbl", "0x0303A" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );

		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_dblexp", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
}
