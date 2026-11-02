// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_spc.h"
#include "expression_term.h"

// --------------------------------------------------------------------
//	[B6] SPC を式の中でも使えるようにする (実機では PRINT 項目専用だが、
//	SPACE$ と同じ実行時生成経路に載せる)。TAB は式では従来通りエラー。
// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_SPC::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	事前計算処理 (SPACE$ と同じ)
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::DEEP) && this->p_operand->is_constant ) {
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			int n = std::stoi( this->p_operand->s_value );
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::STRING;
			p_term->s_value = "";
			for( int i = 0; i < n; i++ ) {
				p_term->s_value = p_term->s_value + " ";
			}
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_SPC::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	先に引数を処理
	this->p_operand->compile( p_info );
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
	this->type = CEXPRESSION_TYPE::STRING;

	p_info->assembler_list.activate_space();
	asm_line.set( "CALL", "", "sub_space" );
	p_info->assembler_list.body.push_back( asm_line );
}
