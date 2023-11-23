// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_and.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_AND::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;
	CEXPRESSION_TERM *p_term;
	CEXPRESSION_NODE *p_node;
	int d1, d2;

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
	//	Ž–‘OŒvŽZˆ—
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant && this->p_right->is_constant ) {
		//	—¼•û’è”‚Ìê‡
		p_term = new CEXPRESSION_TERM();

		d1 = std::stol( this->p_left->s_value );
		if( d1 < -32768 || d1 > 65535 ) {
			p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			return nullptr;
		}
		d2 = std::stol( this->p_right->s_value );
		if( d2 < -32768 || d2 > 65535 ) {
			p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			return nullptr;
		}
		d1 = d1 & d2;
		p_term->type = CEXPRESSION_TYPE::INTEGER;
		p_term->s_value = std::to_string( d1 );
		return p_term;
	}
	else if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant ) {
		//	¶‚¾‚¯’è”‚Ìê‡
		d1 = std::stol( this->p_left->s_value );
		if( d1 < -32768 || d1 > 65535 ) {
			p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			return nullptr;
		}
		if( d1 == 0 ) {
			p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::INTEGER;
			p_term->s_value = "0";
			return p_term;
		}
		if( d1 == -1 || d1 == 65535 ) {
			p_node = this->p_right;
			this->p_right = nullptr;
			return p_node;
		}
	}
	else if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_right->is_constant ) {
		//	‰E‚¾‚¯’è”‚Ìê‡
		d1 = std::stol( this->p_right->s_value );
		if( d1 < -32768 || d1 > 65535 ) {
			p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			return nullptr;
		}
		if( d1 == 0 ) {
			p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::INTEGER;
			p_term->s_value = "0";
			return p_term;
		}
		if( d1 == -1 || d1 == 65535 ) {
			p_node = this->p_left;
			this->p_left = nullptr;
			return p_node;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_AND::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_info );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	¶‘¤‚Ì€‚ª®”Œ^‚Å‚È‚¯‚ê‚ÎA®”Œ^‚É•ÏŠ·‚·‚é
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_info->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_info );

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	‰E‘¤‚Ì€‚ª®”Œ^‚Å‚È‚¯‚ê‚ÎA®”Œ^‚É•ÏŠ·‚·‚é
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	‚±‚Ì‰‰ŽZŽq‚ÌŒ‹‰Ê‚Í•K‚¸®”Œ^
	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.type = CMNEMONIC_TYPE::POP;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "DE";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "L";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::AND;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "E";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "L";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "H";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::AND;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "A";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "D";
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "H";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "A";
	p_info->assembler_list.body.push_back( asm_line );
}
