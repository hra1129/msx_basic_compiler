// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_str.h"
#include "expression_term.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_STR::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	事前計算処理
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::DEEP) && this->p_operand->is_constant ) {
		//	定数の場合
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			//	数値の場合
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			p_term->type = CEXPRESSION_TYPE::STRING;
			char s[256] = "0";
			switch( this->p_operand->type ) {
			default:
			case CEXPRESSION_TYPE::INTEGER:			sprintf( s, "%ld", std::stol( this->p_operand->s_value ) );		break;
			case CEXPRESSION_TYPE::SINGLE_REAL:		sprintf( s, "%1.7f", std::stod( this->p_operand->s_value ) );	break;
			case CEXPRESSION_TYPE::DOUBLE_REAL:		sprintf( s, "%1.14f", std::stod( this->p_operand->s_value ) );	break;
			}
			p_term->s_value = s;
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_STR::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->p_operand == nullptr ) {
		return;
	}
	//	先に引数を処理
	this->p_operand->compile( p_info );

	if( this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
		p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
		p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_dac + 2]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->p_operand->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		p_info->assembler_list.activate_ld_dac_single_real();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "ld_dac_single_real", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->p_operand->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		p_info->assembler_list.activate_ld_dac_double_real();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "ld_dac_double_real", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}

	p_info->assembler_list.activate_str();
	p_info->assembler_list.activate_copy_string();
	this->type = CEXPRESSION_TYPE::STRING;
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "str", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "copy_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
