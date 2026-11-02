// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_vdp.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_VDP::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	[B6] 定数インデックスの範囲チェック (BASE の読み取り側に合わせる)。
	//	実機で有効なのは 0..24, 26, 27, 28 のみで、それ以外は
	//	Illegal function call になる。負数と変数インデックスは実機でも
	//	エラーにならない (隣接ワークを読む) ため、従来通り通す。
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		if( this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
			int id = std::stoi( this->p_operand->s_value );
			if( id >= 0 && !((id <= 24) || id == 26 || id == 27 || id == 28) ) {
				p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
				return nullptr;
			}
		}
	}
	//	VDP関数は最適化で消滅することはない
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_VDP::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	先に引数を処理
	this->p_operand->compile( p_info );

	if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.add_label( "blib_rdvdp", "0x04039" );
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_rdvdp" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
