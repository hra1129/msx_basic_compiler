// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_space.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_SPACE::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

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
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			//	”’l‚Ìê‡
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
void CEXPRESSION_SPACE::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
	this->type = CEXPRESSION_TYPE::STRING;

	p_info->assembler_list.activate_space();
	asm_line.set( "CALL", "", "sub_space" );
	p_info->assembler_list.body.push_back( asm_line );
}
