// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_hex.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_HEX::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	事前計算処理
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		//	定数の場合
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			//	数値の場合
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::STRING;
			int i = (int) std::stod( this->p_operand->s_value );
			if( i < -32768 || i > 65535 ) {
				p_info->errors.add( OVERFLOW_ERROR, p_info->list.get_line_no() );
			}
			i = i & 0x0FFFF;
			std::string s = "";
			while( i ) {
				s = ( "0123456789ABCDEF"[ i & 15 ] ) + s;
				i >>= 4;
			}
			p_term->s_value = s;
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_HEX::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	先に引数を処理
	if( this->p_operand == nullptr ) {
		return;
	}
	this->p_operand->compile( p_info );
	this->convert_type( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER, this->p_operand->type );

	p_info->assembler_list.activate_str();		//	fout_adjust
	p_info->assembler_list.activate_copy_string();
	p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	p_info->assembler_list.add_label( "bios_fouth", "0x03722" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_dac + 2]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_fouth", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "fout_adjust", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "copy_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::STRING;
}
