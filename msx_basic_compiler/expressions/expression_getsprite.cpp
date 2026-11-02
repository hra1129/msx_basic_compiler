// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_getsprite.h"

// --------------------------------------------------------------------
//	[B6] SPRITE$(n) の読み取り: 代入側 (let.cpp) の対になる式の形。
//	VRAM のパターンをライブラリ sub_getsprite が BASIC形式バッファへ
//	読み取り、copy_string_from_buffer でヒープ文字列化する。
// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_GETSPRITE::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_GETSPRITE::compile( CCOMPILE_INFO *p_info ) {
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
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );

	p_info->assembler_list.activate_copy_string_to_buffer();
	p_info->assembler_list.activate_copy_string_from_buffer();
	p_info->assembler_list.add_label( "blib_getsprite", "0x0412c" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "legacy_string_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_getsprite" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "legacy_string_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "copy_string_from_buffer", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::STRING;
}
