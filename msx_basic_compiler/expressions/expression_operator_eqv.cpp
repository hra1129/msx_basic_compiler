// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_eqv.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_EQV::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;
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

	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	エラーなので何もしない
		return nullptr;
	}
	//	事前計算処理
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_left->is_constant && this->p_right->is_constant ) {
		//	両方定数の場合
		CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();

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
		d1 = (~(d1 ^ d2)) & 0x0FFFF;
		p_term->type = CEXPRESSION_TYPE::INTEGER;
		p_term->s_value = std::to_string( d1 );
		return p_term;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_EQV::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	先に項を処理
	this->p_left->compile( p_info );

	if( this->p_left->type == CEXPRESSION_TYPE::STRING ) {
		//	この演算子は文字列型には適用できない
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_left->type != CEXPRESSION_TYPE::INTEGER ) {
		//	左側の項が整数型でなければ、整数型に変換する
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_left->type );
	}

	p_info->assembler_list.push_hl( CEXPRESSION_TYPE::INTEGER );

	this->p_right->compile( p_info );

	if( this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	この演算子は文字列型には適用できない
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	if( this->p_right->type != CEXPRESSION_TYPE::INTEGER ) {
		//	右側の項が整数型でなければ、整数型に変換する
		this->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_right->type );
	}

	//	この演算子の結果は必ず整数型
	this->type = CEXPRESSION_TYPE::INTEGER;

	asm_line.set( "POP", "", "DE", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "A", "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "E" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CPL", "", "", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "L", "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "A", "H" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "D" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CPL", "", "", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "H", "A" );
	p_info->assembler_list.body.push_back( asm_line );
}
