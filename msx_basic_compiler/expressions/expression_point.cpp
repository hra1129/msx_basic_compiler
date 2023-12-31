// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_point.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_POINT::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand1 == nullptr ) {
		return nullptr;
	}
	p = this->p_operand1->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand1;
		this->p_operand1 = p;
	}

	if( this->p_operand2 == nullptr ) {
		return nullptr;
	}
	p = this->p_operand2->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand2;
		this->p_operand2 = p;
	}
	//	POINT関数は最適化で消滅することはない
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_POINT::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand1 == nullptr || this->p_operand2 == nullptr ) {
		return;
	}

	p_info->assembler_list.add_label( "blib_point", "0x040db" );

	//	X座標
	this->p_operand1->compile( p_info );
	this->p_operand1->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand1->type );
	asm_line.set( "PUSH", "", "HL" );		//	X座標を push
	p_info->assembler_list.body.push_back( asm_line );

	//	Y座標
	this->p_operand2->compile( p_info );
	this->p_operand2->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand2->type );
	asm_line.set( "POP", "", "DE" );		//	X座標を pop
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.set( "LD", "", "IX", "blib_point" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
