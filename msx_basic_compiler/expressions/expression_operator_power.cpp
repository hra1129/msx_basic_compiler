// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include <cmath>
#include "expression_operator_power.h"
#include "expression_term.h"

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

	//	事前計算処理
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant && this->p_right->is_constant ) {
		//	定数の場合
		if( this->p_left->type != CEXPRESSION_TYPE::STRING && this->p_right->type != CEXPRESSION_TYPE::STRING ) {
			//	数値の場合
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
			p_term->set_double( pow( std::stod( this->p_left->s_value ), std::stod( this->p_right->s_value ) ) );
			return p_term;
		}
	}

	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant && this->p_left->type != CEXPRESSION_TYPE::STRING ) {
		//	定数の場合
		if(  std::stod( this->p_left->s_value ) == 1.0 ) {
			//	1^n の場合
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
			p_term->set_double( 1.0 );
			return p_term;
		}
		else if(  std::stod( this->p_left->s_value ) == 0.0 ) {
			//	1^n の場合
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
			p_term->set_double( 0.0 );
			return p_term;
		}
	}

	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_right->is_constant && this->p_right->type != CEXPRESSION_TYPE::STRING ) {
		//	定数の場合
		if(  std::stod( this->p_right->s_value ) == 1.0 ) {
			//	n^1 の場合
			CEXPRESSION_NODE* p_node;
			p_node = this->p_left;
			this->p_left = nullptr;
			return p_node;
		}
		else if(  std::stod( this->p_left->s_value ) == 0.0 ) {
			//	n^0 の場合
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
			p_term->set_double( 1.0 );
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_POWER::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	先に項を処理
	this->p_left->compile( p_info );						//	基数
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );						//	指数

	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	この演算子は文字列型には適用できない
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	//	この演算子の演算結果の型は、必ず倍精度
	this->type_adjust_2op( p_info, this->p_left, this->p_right );

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	整数型の場合
		p_info->assembler_list.add_label( "bios_intexp", "0x0383f" );	//	DE ^ HL
		p_info->assembler_list.add_label( "bios_frcdbl", "0x0303A" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );

		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );				//	HL = 指数, DE = 基数
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_intexp", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	実数の場合、倍精度に昇格
		p_info->assembler_list.add_label( "bios_dblexp", "0x037d7" );	//	dac ^ arg
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
