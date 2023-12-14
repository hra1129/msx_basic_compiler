// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_base.h"
#include "expression_term.h"
#include "expression_peekw.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_BASE::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;
	CASSEMBLER_LINE asm_line;
	int base_address[] = {
		//	Name Tbl, Color Tbl, Pattern Tbl, Sp Attr, Sp Pattern
		0x1800, 0x2000, 0x0000, 0x1E00, 0x3800,		//	SCREEN4
		0x0000, 0x0000, 0x0000, 0x7600, 0x7400,		//	SCREEN5
		0x0000, 0x0000, 0x0000, 0x7600, 0x7400,		//	SCREEN6
		0x0000, 0x0000, 0x0000, 0xFA00, 0xF800,		//	SCREEN7
		0x0000, 0x0000, 0x0000, 0xFA00, 0xF800,		//	SCREEN8
		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,		//	-
		0x0000, 0x0000, 0x0000, 0xFA00, 0xF800,		//	SCREEN10
		0x0000, 0x0000, 0x0000, 0xFA00, 0xF800,		//	SCREEN11
		0x0000, 0x0000, 0x0000, 0xFA00, 0xF800,		//	SCREEN12
	};

	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		//	’è”‚Ìê‡
		if( this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
			int id = std::stoi( this->p_operand->s_value );
			if( id < 0 || id > 64 ) {
				p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
				return nullptr;
			}
			if( id < 20 ) {
				int address = 0xF3B3 + id * 2;
				CEXPRESSION_PEEKW *p_peek = new CEXPRESSION_PEEKW();
				CEXPRESSION_TERM *p_address = new CEXPRESSION_TERM();
				p_address->s_value = std::to_string( address );
				p_address->type = CEXPRESSION_TYPE::INTEGER;
				p_peek->p_operand = p_address;
				p_peek->type = CEXPRESSION_TYPE::INTEGER;
				return p_peek;
			}
			if( this->p_operand->s_value.size() != 0 ) {
				CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
				p_term->type = CEXPRESSION_TYPE::INTEGER;
				p_term->s_value = std::to_string( base_address[ id - 20 ] );
				return p_term;
			}
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_BASE::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	æ‚Éˆø”‚ðˆ—
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::INTEGER ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.add_label( "blib_base", "0x0407b" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_base" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	this->type = CEXPRESSION_TYPE::INTEGER;
}
