// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_not.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_NOT::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_right == nullptr ) {
		return nullptr;
	}
	p = this->p_right->optimization( p_info );
	if( p != nullptr ) {
		delete (this->p_right);
		this->p_right = p;
	}

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	�G���[�Ȃ̂ŉ������Ȃ�
		return nullptr;
	}
	//	���O�v�Z����
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_right->is_constant ) {
		//	�萔�̏ꍇ
		if( this->p_right->type != CEXPRESSION_TYPE::STRING ) {
			//	���l�̏ꍇ
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::INTEGER;
			int i = (int) std::stod( this->p_right->s_value );
			if( i < -32768 || i > 65535 ) {
				p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			}
			i = i ^ 0x0FFFF;
			p_term->s_value = std::to_string( i );
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_NOT::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_right == nullptr ) {
		return;
	}
	//	��ɍ�������
	this->p_right->compile( p_info );

	//	���̉��Z�q�̉��Z���ʂ̌^�����߂�
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

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CPL, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CPL, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
}
