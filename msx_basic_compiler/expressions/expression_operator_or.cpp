// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_or.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_OR::optimization( CCOMPILE_INFO *p_info ) {
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
	//	���O�v�Z����
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant && this->p_right->is_constant ) {
		//	�����萔�̏ꍇ
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
		d1 = d1 | d2;
		p_term->type = CEXPRESSION_TYPE::INTEGER;
		p_term->s_value = std::to_string( d1 );
		return p_term;
	}
	else if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant ) {
		//	�������萔�̏ꍇ
		d1 = std::stol( this->p_left->s_value );
		if( d1 < -32768 || d1 > 65535 ) {
			p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			return nullptr;
		}
		if( d1 == 0 ) {
			p_node = this->p_right;
			this->p_right = nullptr;
			return p_node;
		}
		if( d1 == -1 || d1 == 65535 ) {
			p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::INTEGER;
			p_term->s_value = "-1";
			return p_term;
		}
	}
	else if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_right->is_constant ) {
		//	�E�����萔�̏ꍇ
		d1 = std::stol( this->p_right->s_value );
		if( d1 < -32768 || d1 > 65535 ) {
			p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			return nullptr;
		}
		if( d1 == 0 ) {
			p_node = this->p_left;
			this->p_left = nullptr;
			return p_node;
		}
		if( d1 == -1 || d1 == 65535 ) {
			p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::INTEGER;
			p_term->s_value = "-1";
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_OR::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	��ɍ�������
	this->p_left->compile( p_info );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	�����̍��������^�łȂ���΁A�����^�ɕϊ�����
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_info->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_info );

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	���̉��Z�q�͕�����^�ɂ͓K�p�ł��Ȃ�
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	�E���̍��������^�łȂ���΁A�����^�ɕϊ�����
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	���̉��Z�q�̌��ʂ͕K�������^
	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "E" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "D" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
}
