// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_asc.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_ASC::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		//	’è”‚Ìê‡
		if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
			//	•¶Žš—ñ‚Ìê‡
			if( this->p_operand->s_value.size() != 0 ) {
				CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
				p_term->type = CEXPRESSION_TYPE::INTEGER;
				p_term->s_value = std::to_string( (int)(unsigned char)this->p_operand->s_value[0] );
				return p_term;
			}
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_ASC::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	if( this->p_operand == nullptr ) {
		return;
	}
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	asm_line.set( "INC", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "DEC", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "AF"  );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string"  );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "AF" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "L", "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "H", "0" );
	p_info->assembler_list.body.push_back( asm_line );

	this->type = CEXPRESSION_TYPE::INTEGER;
}
