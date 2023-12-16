// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_hexchr.h"
#include "expression_term.h"

// --------------------------------------------------------------------
int CEXPRESSION_HEXCHR::hexchr( int c ) {

	if( c <= '9' ) {
		c -= '0';
	}
	else {
		c = c | 0x60;
		c -= 'a' - 10;
	}
	return c;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_HEXCHR::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;
	int i, n, d;

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
			p_term->s_value.resize( n >> 1 );
			for( i = 0; i < (n >> 1); i++ ) {
				d = hexchr( (int)(unsigned char)this->p_operand->s_value[ i * 2 + 0 ] ) << 4;
				d = hexchr( (int)(unsigned char)this->p_operand->s_value[ i * 2 + 1 ] ) | d;
				p_term->s_value[ i ] = (char) d;
			}
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_HEXCHR::compile( CCOMPILE_INFO *p_info ) {
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
	p_info->assembler_list.activate_allocate_string();
	p_info->assembler_list.activate_free_string();
	p_info->assembler_list.add_label( "blib_hexchr", "0x04093" );

	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "IX", "blib_hexchr" );
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
