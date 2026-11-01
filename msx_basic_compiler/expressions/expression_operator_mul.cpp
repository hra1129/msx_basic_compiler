// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_mul.h"
#include "expression_term.h"
#include "expression_variable.h"
#include "expression_operator_minus.h"

// --------------------------------------------------------------------
//	[B5] 定数との整数乗算の強度削減のための判定・生成ヘルパー
//
//	整数 × 整数定数 の乗算は、通常 BIOS_IMULT 呼び出しになる。
//	結果が16ビットに収まる範囲では IMULT の結果は正確だが、
//	桁あふれした場合は 2^16 で丸めた値にはならず、実測では
//	-2050 (0xF7FE) が返る (例外的に -32768 × -1 では -2058)。
//	これは IMULT が桁あふれ時に浮動小数点経路へ移る際の残留値で、
//	シフト+加算列で再現するには各ステップの桁あふれ検査が必要になり、
//	「定数のロード (3B) + PUSH HL (1B) + POP DE (1B) +
//	CALL BIOS_IMULT (3B) = 8バイト」という置換上限を超えてしまう。
//	そのため展開対象は、桁あふれの扱いまで含めて IMULT と完全一致
//	させられる k = 0, 1 のみとする。
//	・k = 0: 結果は常に 0 で桁あふれしない (LD HL, 0)
//	・k = 1: 恒等 (何もしない)
//	k = 2 は ADD HL,HL + JP PO で桁あふれを検査すれば 7バイトに
//	収まるが、R800 (MSX turbo R) では ADD HL,HL 後の P/V が符号付き
//	桁あふれを示さない (実測: 0x4000+0x4000 でも P/V=0) ため、
//	Z80 専用の前提になるその形は採用しない。
//	それ以外の定数 (負数を含む) は従来通り IMULT を使う。

// --------------------------------------------------------------------
//	ノードが整数定数項であれば、その値を value に入れて true を返す
static bool get_integer_constant( CEXPRESSION_NODE *p_node, int &value ) {
	CEXPRESSION_TERM *p_term;
	double r;

	if( p_node == nullptr || !p_node->is_constant || p_node->type != CEXPRESSION_TYPE::INTEGER ) {
		return false;
	}
	p_term = dynamic_cast<CEXPRESSION_TERM*>( p_node );
	if( p_term == nullptr ) {
		return false;
	}
	r = p_term->get_value();
	if( r < -32768.0 || r > 32767.0 || r != (double)(int)r ) {
		return false;
	}
	value = (int)r;
	return true;
}

// --------------------------------------------------------------------
//	ノードのコンパイル結果が整数 (HL) になることが静的に分かるか
//	(整数定数項、または整数変数の読み取り。配列要素も含む)
static bool is_integer_valued_node( CEXPRESSION_NODE *p_node ) {
	CEXPRESSION_VARIABLE *p_variable;

	if( p_node == nullptr ) {
		return false;
	}
	if( p_node->is_constant ) {
		return p_node->type == CEXPRESSION_TYPE::INTEGER;
	}
	p_variable = dynamic_cast<CEXPRESSION_VARIABLE*>( p_node );
	if( p_variable != nullptr ) {
		return p_variable->variable.type == CVARIABLE_TYPE::INTEGER;
	}
	return false;
}

// --------------------------------------------------------------------
//	HL = HL * k の展開列のバイト数を返す。展開対象外なら -1。
//	置換前の IMULT 一式は 8バイトなので、展開列はそれ以下に収める。
static int const_mul_sequence_size( int k ) {
	if( k == 0 ) {
		return 3;	//	LD HL, 0
	}
	if( k == 1 ) {
		return 0;	//	何もしない
	}
	return -1;
}

// --------------------------------------------------------------------
//	HL = HL * k の展開列を生成する (const_mul_sequence_size(k) >= 0 前提)
static void emit_const_mul_sequence( CCOMPILE_INFO *p_info, int k ) {
	CASSEMBLER_LINE asm_line;

	if( k == 0 ) {
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
		return;
	}
	//	k == 1 は恒等なので何もしない
}

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
		//	左右の項が両方とも定数の場合
		CEXPRESSION_TERM *p_left  = reinterpret_cast<CEXPRESSION_TERM*> (this->p_left);
		CEXPRESSION_TERM *p_right = reinterpret_cast<CEXPRESSION_TERM*> (this->p_right);
		double r = p_left->get_value() * p_right->get_value();

		CEXPRESSION_TERM *p_term  = new CEXPRESSION_TERM();
		p_term->set_type( p_left->type, p_right->type );
		p_term->set_double( r );
		return p_term;
	}
	if( this->p_left->is_constant ) {
		//	左の項が定数
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
			p_minus->p_right = p_right;
			this->p_right = nullptr;
			return p_minus;
		}
	}
	if( this->p_right->is_constant ) {
		//	右の項が定数
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
			p_minus->p_right = p_left;
			this->p_left = nullptr;
			return p_minus;
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
	//	[B5] 片方が整数定数で、もう片方の結果が整数になることが静的に
	//	分かる場合は、BIOS_IMULT を呼ばずに展開する (B5)。
	//	被乗数側の評価は従来形でも必ず行われるので、展開しても
	//	評価の有無や順序は変わらない。
	{
		int k = 0;
		CEXPRESSION_NODE *p_value = nullptr;

		if( get_integer_constant( this->p_right, k ) && is_integer_valued_node( this->p_left ) ) {
			p_value = this->p_left;
		}
		else if( get_integer_constant( this->p_left, k ) && is_integer_valued_node( this->p_right ) ) {
			p_value = this->p_right;
		}
		if( p_value != nullptr && const_mul_sequence_size( k ) >= 0 ) {
			p_value->compile( p_info );
			emit_const_mul_sequence( p_info, k );
			this->type = CEXPRESSION_TYPE::INTEGER;
			return;
		}
	}
	//	先に項を処理
	this->p_left->compile( p_info );
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );

	//	この演算子の演算結果の型を決める
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	この演算子は文字列型には適用できない
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	this->type_adjust_2op( p_info, this->p_left, this->p_right );

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	整数の場合
		p_info->assembler_list.add_label( "bios_imult", "0x03193" );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_imult", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	実数の場合
		p_info->assembler_list.add_label( "bios_decmul", "0x027e6" );
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_decmul", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
