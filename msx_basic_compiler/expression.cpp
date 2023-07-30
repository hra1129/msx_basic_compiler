// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include "expression.h"
#include "expression_operator_eqv.h"
#include "expression_operator_imp.h"
#include "expression_operator_xor.h"
#include "expression_operator_or.h"
#include "expression_operator_and.h"
#include "expression_operator_not.h"
#include "expression_operator_equ.h"
#include "expression_operator_neq.h"
#include "expression_operator_gt.h"
#include "expression_operator_ge.h"
#include "expression_operator_lt.h"
#include "expression_operator_le.h"
#include "expression_operator_add.h"
#include "expression_operator_sub.h"
#include "expression_operator_intdiv.h"
#include "expression_operator_mod.h"
#include "expression_operator_mul.h"
#include "expression_operator_div.h"
#include "expression_operator_minus.h"
#include "expression_function.h"

// --------------------------------------------------------------------
void CEXPRESSION::optimization( void ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_brackets( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_function( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_power( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_minus_plus( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_mul_div( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_intdiv( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_mod( CCOMPILER *p_this ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_add_sub( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_ADD *p_operator_add;
	CEXPRESSION_OPERATOR_SUB *p_operator_sub;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_mod( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "+" && p_this->p_position->s_word != "-" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		if( p_this->p_position->s_word == "=" ) {
			p_operator_add = new CEXPRESSION_OPERATOR_ADD;
			p_operator_add->p_left = p_result;
			p_operator_add->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_add;
		}
		else {
			//	if( p_this->p_position->s_word == "-" )
			p_operator_sub = new CEXPRESSION_OPERATOR_SUB;
			p_operator_sub->p_left = p_result;
			p_operator_sub->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_sub;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_compare( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_EQU *p_operator_equ;
	CEXPRESSION_OPERATOR_NEQ *p_operator_neq;
	CEXPRESSION_OPERATOR_GT *p_operator_gt;
	CEXPRESSION_OPERATOR_GE *p_operator_ge;
	CEXPRESSION_OPERATOR_LT *p_operator_lt;
	CEXPRESSION_OPERATOR_LE *p_operator_le;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_add_sub( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "=" && p_this->p_position->s_word != "<>" && p_this->p_position->s_word != "><" && 
			p_this->p_position->s_word != ">=" && p_this->p_position->s_word != "=>" && p_this->p_position->s_word != ">" &&
			p_this->p_position->s_word != "<=" && p_this->p_position->s_word != "=<" && p_this->p_position->s_word != "<" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		if( p_this->p_position->s_word == "=" ) {
			p_operator_equ = new CEXPRESSION_OPERATOR_EQU;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_equ;
		}
		else if( p_this->p_position->s_word == "<>" || p_this->p_position->s_word == "><" ) {
			p_operator_neq = new CEXPRESSION_OPERATOR_NEQ;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_equ;
		}
		else if( p_this->p_position->s_word == ">" ) {
			p_operator_gt = new CEXPRESSION_OPERATOR_GT;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_equ;
		}
		else if( p_this->p_position->s_word == "<" ) {
			p_operator_lt = new CEXPRESSION_OPERATOR_LT;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_equ;
		}
		else if( p_this->p_position->s_word == ">=" || p_this->p_position->s_word == "=>" ) {
			p_operator_ge = new CEXPRESSION_OPERATOR_GE;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_equ;
		}
		else { 
			//	if( p_this->p_position->s_word == "<=" || p_this->p_position->s_word == "=<" )
			p_operator_le = new CEXPRESSION_OPERATOR_LE;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_not( CCOMPILER *p_this ) {
	CEXPRESSION_OPERATOR_NOT *p_operator;

	if( p_this->p_position->s_word != "NOT" ) {
		//	所望の演算子ではないので右項をそのまま返す
		return this->makeup_node_operator_compare( p_this );
	}
	p_this->p_position++;
	if( p_this->is_line_end() ) {
		p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
		return nullptr;
	}
	//	この演算子のインスタンスを生成
	p_operator = new CEXPRESSION_OPERATOR_NOT;
	p_operator->p_right = this->makeup_node_operator_not( p_this );
	return p_operator;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_and( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_AND *p_operator;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_not( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "AND" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_AND;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_not( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_or( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_OR *p_operator;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_and( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "OR" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_OR;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_and( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_xor( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_XOR *p_operator;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_or( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "XOR" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_XOR;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_or( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_imp( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_IMP *p_operator;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_or( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "IMP" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_IMP;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_or( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_eqv( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_NODE *p_right;
	CEXPRESSION_OPERATOR_EQV *p_operator;
	CEXPRESSION_NODE *p_result;

	//	左項を得る
	p_left = this->makeup_node_operator_imp( p_this );
	p_result = p_left;
	while( !p_this->is_line_end() ) {
		if( p_this->p_position->s_word != "EQV" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_position++;
		if( p_this->is_line_end() ) {
			p_this->p_errors->add( "Syntax error.", p_this->get_line_no() );	//	あるべき右項が居ない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_EQV;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_imp( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
void CEXPRESSION::makeup_node( CCOMPILER *p_this ) {

	this->p_top_node = this->makeup_node_operator_eqv( p_this );
}

// --------------------------------------------------------------------
void CEXPRESSION::compile( CCOMPILER *p_this ) {
}
