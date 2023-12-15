// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_vpeeks.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_VPEEKS::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand1 == nullptr || this->p_operand2 == nullptr ) {
		return nullptr;
	}
	p = this->p_operand1->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand1;
		this->p_operand1 = p;
	}
	p = this->p_operand2->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand2;
		this->p_operand2 = p;
	}
	//	PEEKS関数は最適化で消滅することはない
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_VPEEKS::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand1 == nullptr || this->p_operand2 == nullptr ) {
		return;
	}

	p_info->assembler_list.activate_allocate_string();
	p_info->assembler_list.add_label( "blib_vpeeks", "0x04090" );

	//	アドレス値を計算
	this->p_operand1->compile( p_info );
	this->p_operand1->convert_type( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER, this->p_operand1->type );
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );

	//	文字列長を計算
	this->p_operand2->compile( p_info );
	this->p_operand2->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand2->type );
	//	文字列長に従って文字列を確保
	asm_line.set( "LD", "", "A", "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_string", "" );
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.set( "POP", "", "DE", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "IX", "blib_vpeeks" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::STRING;
}
