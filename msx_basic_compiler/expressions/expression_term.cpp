// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_TERM::optimization( CCOMPILE_INFO *p_info ) {
	
	//	term ‚ÍA‚±‚êˆÈãÅ“K‰»‚Å‚«‚È‚¢
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_TERM::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		int i = 0;
		(void) sscanf( this->s_value.c_str(), "%i", &i );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, std::to_string( i ) );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		CSINGLE_REAL value;
		value.set( this->s_value );
		std::string s_label = p_info->constants.add( value );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		CDOUBLE_REAL value;
		value.set( this->s_value );
		std::string s_label = p_info->constants.add( value );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::STRING ) {
		CSTRING value;
		value.set( this->s_value );
		std::string s_label = p_info->constants.add( value );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
