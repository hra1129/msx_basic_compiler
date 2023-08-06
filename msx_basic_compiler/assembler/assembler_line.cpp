// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include "assembler_line.h"
#include <cstring>

// --------------------------------------------------------------------
bool CASSEMBLER_LINE::save( FILE *p_file, COUTPUT_TYPES output_type ) {

	if( this->type == CMNEMONIC_TYPE::COMMENT ) {
		fprintf( p_file, "\t; %s\n", this->operand1.s_value.c_str() );
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::LABEL ) {
		fprintf( p_file, "%s:\n", this->operand1.s_value.c_str() );
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::CONSTANT ) {
		if( output_type == COUTPUT_TYPES::ZMA ) {
			fprintf( p_file, "%s = %s\n", this->operand1.s_value.c_str(), this->operand2.s_value.c_str() );
		}
		else {
			if( this->operand2.type == COPERAND_TYPE::CONSTANT ) {
				int value = 0;
				sscanf_s( this->operand2.s_value.c_str(), "%i", &value );
				fprintf( p_file, "%s equ 0%04Xh\n", this->operand1.s_value.c_str(), value );
			}
			else {
				fprintf( p_file, "%s equ %s\n", this->operand1.s_value.c_str(), this->operand2.s_value.c_str() );
			}
		}
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::CALL ) {
		fprintf( p_file, "\tCALL\t%s\n", this->operand1.s_value.c_str() );
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::JP ) {
		fprintf( p_file, "\tJP\t\t%s\n", this->operand1.s_value.c_str() );
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::RET ) {
		if( this->condition == CCONDITION::NONE ) {
			fprintf( p_file, "\tRET\n" );
		}
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::POP ) {
		fprintf( p_file, "\tPOP\t\t%s\n", this->operand1.s_value.c_str() );
		return true;
	}
	return true;
}
