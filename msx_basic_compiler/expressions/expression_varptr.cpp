// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_varptr.h"
#include "../compiler.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_VARPTR::optimization( CCOMPILE_INFO *p_info ) {

	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_VARPTR::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_file_type ) {
		//	#n ÇÃèÍçá
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "fcb_" + std::to_string( this->file_number ) );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	ïœêî ÇÃèÍçá
		std::vector< CBASIC_WORD >::const_iterator p_position = p_info->list.p_position;
		p_info->list.p_position = this->p_position;
		CVARIABLE variable = p_info->p_compiler->get_variable_address();
		p_info->list.p_position = p_position;
	}
	this->type = CEXPRESSION_TYPE::INTEGER;
}
