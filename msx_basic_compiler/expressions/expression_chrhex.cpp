// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_chrhex.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_CHRHEX::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;
	int i, n;
	const char chrhex[] = "0123456789ABCDEF";

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	Ž–‘OŒvŽZˆ—
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::DEEP) && this->p_operand->is_constant ) {
		//	’è”‚Ìê‡
		if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
			//	•¶Žš—ñ‚Ìê‡
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::STRING;
			n = (int) this->p_operand->s_value.size();
			if( n > 127 ) {
				p_info->errors.add( STRING_TOO_LONG, p_info->list.get_line_no() );
				return nullptr;
			}
			p_term->s_value.resize( n * 2 );
			for( i = 0; i < n; i++ ) {
				p_term->s_value[ i * 2 + 0 ] = chrhex[ (this->p_operand->s_value[i] >> 4) & 0x0F ];
				p_term->s_value[ i * 2 + 1 ] = chrhex[ (this->p_operand->s_value[i]     ) & 0x0F ];
			}
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_CHRHEX::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.activate_copy_string();
	p_info->assembler_list.activate_free_string();
	p_info->assembler_list.add_label( "blib_chrhex", "0x04096" );

	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "IX", "blib_chrhex" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::STRING;
}
