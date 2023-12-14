// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_mul.h"
#include "expression_term.h"
#include "expression_operator_minus.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_MUL::optimization( CCOMPILE_INFO *p_info ) {
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

	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		return nullptr;
	}

	if( this->p_left->is_constant && this->p_right->is_constant ) {
		//	¶‰E‚Ì€‚ª—¼•û‚Æ‚à’è”‚Ìê‡
		CEXPRESSION_TERM *p_left  = reinterpret_cast<CEXPRESSION_TERM*> (this->p_left);
		CEXPRESSION_TERM *p_right = reinterpret_cast<CEXPRESSION_TERM*> (this->p_right);
		double r = p_left->get_value() * p_right->get_value();

		CEXPRESSION_TERM *p_term  = new CEXPRESSION_TERM();
		p_term->set_type( p_left->type, p_right->type );
		p_term->set_double( r );
		return p_term;
	}
	if( this->p_left->is_constant ) {
		//	¶‚Ì€‚ª’è”
		CEXPRESSION_TERM *p_left  = reinterpret_cast<CEXPRESSION_TERM*> (this->p_left);
		CEXPRESSION_NODE *p_right = this->p_right;
		double r = p_left->get_value();
		if( r == 1.0 ) {
			this->p_right = nullptr;
			return p_right;
		}
		if( r == 0.0 ) {
			this->p_left = nullptr;
			return p_left;
		}
		if( r == -1.0 ) {
			CEXPRESSION_OPERATOR_MINUS *p_minus = new CEXPRESSION_OPERATOR_MINUS();
			p_minus->type = p_right->type;
			this->p_right = nullptr;
			return p_right;
		}
	}
	if( this->p_right->is_constant ) {
		//	‰E‚Ì€‚ª’è”
		CEXPRESSION_TERM *p_right  = reinterpret_cast<CEXPRESSION_TERM*> (this->p_right);
		CEXPRESSION_NODE *p_left = this->p_left;
		double r = p_right->get_value();
		if( r == 1.0 ) {
			this->p_left = nullptr;
			return p_left;
		}
		if( r == 0.0 ) {
			this->p_right = nullptr;
			return p_right;
		}
		if( r == -1.0 ) {
			CEXPRESSION_OPERATOR_MINUS *p_minus = new CEXPRESSION_OPERATOR_MINUS();
			p_minus->type = p_left->type;
			this->p_left = nullptr;
			return p_left;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_MUL::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	æ‚É€‚ğˆ—
	this->p_left->compile( p_info );
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );

	//	‚±‚Ì‰‰Zq‚Ì‰‰ZŒ‹‰Ê‚ÌŒ^‚ğŒˆ‚ß‚é
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰Zq‚Í•¶š—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	this->type_adjust_2op( p_info, this->p_left, this->p_right );

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	®”‚Ìê‡
		p_info->assembler_list.add_label( "bios_imult", "0x03193" );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_imult", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	À”‚Ìê‡
		p_info->assembler_list.add_label( "bios_decmul", "0x027e6" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_decmul", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
