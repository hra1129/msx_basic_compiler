// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_play.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_PLAY::optimization( CCOMPILE_INFO *p_info ) {
	if( this->p_operand != nullptr ) {
		CEXPRESSION_NODE *p = this->p_operand->optimization( p_info );
		if( p != nullptr ) {
			delete this->p_operand;
			this->p_operand = p;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_PLAY::compile( CCOMPILE_INFO *p_info ) {
	if( this->p_operand == nullptr ) {
		return;
	}
	this->p_operand->compile( p_info );
	if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
	p_info->assembler_list.add_label( "blib_play_status", "0x04102" );
	CASSEMBLER_LINE asm_line;
	asm_line.set( "LD", "", "IX", "blib_play_status" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
