// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "../compile_info.h"

#ifndef __EXPRESSION_H__
#define __EXPRESSION_H__

// --------------------------------------------------------------------
enum class CEXPRESSION_TYPE: int {
	UNKNOWN = 0,
	INTEGER = 1,
	SINGLE_REAL = 2,
	DOUBLE_REAL = 3,
	STRING = 4,
};

// --------------------------------------------------------------------
class CEXPRESSION_NODE {
public:
	// --------------------------------------------------------------------
	//	この式の型
	CEXPRESSION_TYPE type;

	// ----------------------------------------------------------------
	//	コンストラクタ
	CEXPRESSION_NODE() {
		this->type = CEXPRESSION_TYPE::UNKNOWN;
	}

	// ----------------------------------------------------------------
	//	解放
	virtual void release( void ) {
	}

	// ----------------------------------------------------------------
	//	デストラクタ
	virtual ~CEXPRESSION_NODE() {
		this->release();
	}

	// ----------------------------------------------------------------
	//	コンパイル処理
	virtual void compile( CCOMPILE_INFO *p_this ) = 0;

	// ----------------------------------------------------------------
	//	演算式ツリーの中で事前に演算可能なモノは演算してしまう
	virtual void optimization( void ) = 0;
};

// --------------------------------------------------------------------
class CEXPRESSION {
private:
	// ----------------------------------------------------------------
	//	演算式ツリーの実体
	CEXPRESSION_NODE *p_top_node;

	// ----------------------------------------------------------------
	//	演算式ツリーの中で事前に演算可能なモノは演算してしまう
	void optimization( void );

	// ----------------------------------------------------------------
	CEXPRESSION_NODE *makeup_node_brackets( CCOMPILE_INFO *p_this );					//	( ) 括弧
	CEXPRESSION_NODE *makeup_node_term( CCOMPILE_INFO *p_this );						//	関数, FN関数
	CEXPRESSION_NODE *makeup_node_operator_power( CCOMPILE_INFO *p_this );				//	^ 累乗
	CEXPRESSION_NODE *makeup_node_operator_minus_plus( CCOMPILE_INFO *p_this );			//	- + 符号
	CEXPRESSION_NODE *makeup_node_operator_mul_div( CCOMPILE_INFO *p_this );			//	* / 乗算、除算
	CEXPRESSION_NODE *makeup_node_operator_intdiv( CCOMPILE_INFO *p_this );				//	￥ 整数除算
	CEXPRESSION_NODE *makeup_node_operator_mod( CCOMPILE_INFO *p_this );				//	MOD 余り
	CEXPRESSION_NODE *makeup_node_operator_add_sub( CCOMPILE_INFO *p_this );			//	+ - 加減算
	CEXPRESSION_NODE *makeup_node_operator_compare( CCOMPILE_INFO *p_this );			//	= <> >< < <= =< > >= => 比較
	CEXPRESSION_NODE *makeup_node_operator_not( CCOMPILE_INFO *p_this );				//	NOT 反転
	CEXPRESSION_NODE *makeup_node_operator_and( CCOMPILE_INFO *p_this );				//	AND 論理積
	CEXPRESSION_NODE *makeup_node_operator_or( CCOMPILE_INFO *p_this );					//	OR 論理和
	CEXPRESSION_NODE *makeup_node_operator_xor( CCOMPILE_INFO *p_this );				//	XOR 排他的論理和
	CEXPRESSION_NODE *makeup_node_operator_imp( CCOMPILE_INFO *p_this );				//	IMP 包含
	CEXPRESSION_NODE *makeup_node_operator_eqv( CCOMPILE_INFO *p_this );				//	EQV 同値
public:
	// ----------------------------------------------------------------
	//	コンストラクタ
	CEXPRESSION() {
		this->p_top_node = nullptr;
	}

	// ----------------------------------------------------------------
	//	デストラクタ
	~CEXPRESSION() {
		this->release();
	}

	// ----------------------------------------------------------------
	//	解放
	void release( void ) {
		if( this->p_top_node != nullptr ) {
			delete (this->p_top_node);
			this->p_top_node = nullptr;
		}
	}

	// ----------------------------------------------------------------
	//	ソースコードを解釈して、演算式ツリーを形成する
	void makeup_node( CCOMPILE_INFO *p_this );

	// ----------------------------------------------------------------
	//	演算式ツリーからアセンブリコードを生成する
	//	式が省略されていた場合は、false を返す
	bool compile( CCOMPILE_INFO *p_this, CEXPRESSION_TYPE target = CEXPRESSION_TYPE::INTEGER );
};

#endif
