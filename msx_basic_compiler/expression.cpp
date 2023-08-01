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
#include "expression_operator_power.h"
#include "expression_function.h"

// --------------------------------------------------------------------
void CEXPRESSION::optimization( void ) {
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_term( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	if( p_this->p_list->is_line_end() ) {
		return nullptr;															//	値が無い場合は nullptr を返す
	}
	s_operator = p_this->p_list->p_position->s_word;
	if( s_operator == "(" ) {
		p_this->p_list->p_position++;
		p_result = this->makeup_node_operator_eqv( p_this );
		if( p_this->p_list->is_line_end() || p_this->p_list->p_position->s_word != ")" ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき閉じ括弧
			return p_result;
		}
		p_this->p_list->p_position++;
		return p_result;
	}
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_power( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_POWER *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_term( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "^" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_POWER;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_term( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_minus_plus( CCOMPILER *p_this ) {
	CEXPRESSION_OPERATOR_MINUS *p_operator_minus;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	if( p_this->p_list->is_line_end() ) {
		return nullptr;
	}
	s_operator = p_this->p_list->p_position->s_word;
	if( s_operator != "+" && s_operator != "-" ) {
		//	所望の演算子ではない
		return this->makeup_node_operator_power( p_this );
	}
	p_this->p_list->p_position++;
	if( p_this->p_list->is_line_end() ) {
		p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
		return nullptr;
	}
	//	この演算子の処理
	if( s_operator == "+" ) {
		//	+ は実質何もしない
		return this->makeup_node_operator_minus_plus( p_this );
	}
	else {
		//	if( s_operator == "-" )
		p_operator_minus = new CEXPRESSION_OPERATOR_MINUS;
		p_operator_minus->p_right = this->makeup_node_operator_minus_plus( p_this );
		p_result = p_operator_minus;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_mul_div( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_MUL *p_operator_mul;
	CEXPRESSION_OPERATOR_DIV *p_operator_div;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_mod( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "*" && s_operator != "/" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
			break;
		}
		//	この演算子のインスタンスを生成
		if( s_operator == "*" ) {
			p_operator_mul = new CEXPRESSION_OPERATOR_MUL;
			p_operator_mul->p_left = p_result;
			p_operator_mul->p_right = this->makeup_node_operator_minus_plus( p_this );
			p_result = p_operator_mul;
		}
		else {
			//	if( s_operator == "-" )
			p_operator_div = new CEXPRESSION_OPERATOR_DIV;
			p_operator_div->p_left = p_result;
			p_operator_div->p_right = this->makeup_node_operator_minus_plus( p_this );
			p_result = p_operator_div;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_intdiv( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_INTDIV *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_mul_div( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "\\" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_INTDIV;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_mul_div( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_mod( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_MOD *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_intdiv( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "MOD" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
			break;
		}
		//	この演算子のインスタンスを生成
		p_operator = new CEXPRESSION_OPERATOR_MOD;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_intdiv( p_this );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_add_sub( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_ADD *p_operator_add;
	CEXPRESSION_OPERATOR_SUB *p_operator_sub;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_mod( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "+" && s_operator != "-" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
			break;
		}
		//	この演算子のインスタンスを生成
		if( s_operator == "+" ) {
			p_operator_add = new CEXPRESSION_OPERATOR_ADD;
			p_operator_add->p_left = p_result;
			p_operator_add->p_right = this->makeup_node_operator_mod( p_this );
			p_result = p_operator_add;
		}
		else {
			//	if( s_operator == "-" )
			p_operator_sub = new CEXPRESSION_OPERATOR_SUB;
			p_operator_sub->p_left = p_result;
			p_operator_sub->p_right = this->makeup_node_operator_mod( p_this );
			p_result = p_operator_sub;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_compare( CCOMPILER *p_this ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_EQU *p_operator_equ;
	CEXPRESSION_OPERATOR_NEQ *p_operator_neq;
	CEXPRESSION_OPERATOR_GT *p_operator_gt;
	CEXPRESSION_OPERATOR_GE *p_operator_ge;
	CEXPRESSION_OPERATOR_LT *p_operator_lt;
	CEXPRESSION_OPERATOR_LE *p_operator_le;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_add_sub( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "=" && s_operator != "<>" && s_operator != "><" && 
			s_operator != ">=" && s_operator != "=>" && s_operator != ">" &&
			s_operator != "<=" && s_operator != "=<" && s_operator != "<" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
			break;
		}
		//	この演算子のインスタンスを生成
		if( s_operator == "=" ) {
			p_operator_equ = new CEXPRESSION_OPERATOR_EQU;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_equ;
		}
		else if( s_operator == "<>" || s_operator == "><" ) {
			p_operator_neq = new CEXPRESSION_OPERATOR_NEQ;
			p_operator_neq->p_left = p_result;
			p_operator_neq->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_neq;
		}
		else if( s_operator == ">" ) {
			p_operator_gt = new CEXPRESSION_OPERATOR_GT;
			p_operator_gt->p_left = p_result;
			p_operator_gt->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_gt;
		}
		else if( s_operator == "<" ) {
			p_operator_lt = new CEXPRESSION_OPERATOR_LT;
			p_operator_lt->p_left = p_result;
			p_operator_lt->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_lt;
		}
		else if( s_operator == ">=" || s_operator == "=>" ) {
			p_operator_ge = new CEXPRESSION_OPERATOR_GE;
			p_operator_ge->p_left = p_result;
			p_operator_ge->p_right = this->makeup_node_operator_add_sub( p_this );
			p_result = p_operator_ge;
		}
		else { 
			//	if( s_operator == "<=" || s_operator == "=<" )
			p_operator_le = new CEXPRESSION_OPERATOR_LE;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_not( CCOMPILER *p_this ) {
	CEXPRESSION_OPERATOR_NOT *p_operator;
	std::string s_operator;

	s_operator = p_this->p_list->p_position->s_word;
	if( s_operator != "NOT" ) {
		//	所望の演算子ではないので右項をそのまま返す
		return this->makeup_node_operator_compare( p_this );
	}
	p_this->p_list->p_position++;
	if( p_this->p_list->is_line_end() ) {
		p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
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
	CEXPRESSION_OPERATOR_AND *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_not( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "AND" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
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
	CEXPRESSION_OPERATOR_OR *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_and( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "OR" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
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
	CEXPRESSION_OPERATOR_XOR *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_or( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "XOR" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
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
	CEXPRESSION_OPERATOR_IMP *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_or( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "IMP" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
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
	CEXPRESSION_OPERATOR_EQV *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	左項を得る
	p_left = this->makeup_node_operator_imp( p_this );
	if( p_left == nullptr ) {
		return nullptr;				//	左項が得られなかった場合
	}
	p_result = p_left;
	while( !p_this->p_list->is_line_end() ) {
		s_operator = p_this->p_list->p_position->s_word;
		if( s_operator != "EQV" ) {
			//	所望の演算子ではないので左項をそのまま返す
			break;
		}
		p_this->p_list->p_position++;
		if( p_this->p_list->is_line_end() ) {
			p_this->p_errors->add( "Missing operand.", p_this->p_list->get_line_no() );	//	あるべき右項がない
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
