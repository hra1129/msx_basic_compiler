// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include "expression.h"

#include "expression_operator_eqv.h"
#include "expression_operator_imp.h"
#include "expression_operator_xor.h"
#include "expression_operator_or.h"
#include "expression_operator_and.h"
#include "expression_operator_not.h"
#include "expression_operator_equ.h"
#include "expression_operator_neq.h"
#include "expression_operator_gt.h"
#include "expression_operator_ge.h"
#include "expression_operator_lt.h"
#include "expression_operator_le.h"
#include "expression_operator_add.h"
#include "expression_operator_sub.h"
#include "expression_operator_intdiv.h"
#include "expression_operator_mod.h"
#include "expression_operator_mul.h"
#include "expression_operator_div.h"
#include "expression_operator_minus.h"
#include "expression_operator_power.h"
#include "expression_function.h"
#include "expression_term.h"
#include "expression_variable.h"

#include "expression_abs.h"
#include "expression_asc.h"
#include "expression_atn.h"
#include "expression_bin.h"
#include "expression_cdbl.h"
#include "expression_chr.h"
#include "expression_cint.h"
#include "expression_cos.h"
#include "expression_csng.h"
#include "expression_csrlin.h"
#include "expression_exp.h"
#include "expression_fix.h"
#include "expression_fre.h"
#include "expression_hex.h"
#include "expression_inkey.h"
#include "expression_inp.h"
#include "expression_int.h"
#include "expression_instr.h"
#include "expression_left.h"
#include "expression_len.h"
#include "expression_log.h"
#include "expression_mid.h"
#include "expression_oct.h"
#include "expression_pad.h"
#include "expression_peek.h"
#include "expression_right.h"
#include "expression_rnd.h"
#include "expression_sgn.h"
#include "expression_str.h"
#include "expression_string.h"
#include "expression_sgn.h"
#include "expression_sin.h"
#include "expression_stick.h"
#include "expression_strig.h"
#include "expression_tan.h"
#include "expression_time.h"
#include "expression_usr.h"
#include "expression_val.h"
#include "expression_varptr.h"
#include "expression_vdp.h"
#include "expression_vpeek.h"

// --------------------------------------------------------------------
void CEXPRESSION::optimization( void ) {
}

// --------------------------------------------------------------------
void CEXPRESSION_NODE::type_adjust_2op( CCOMPILE_INFO *p_info, CEXPRESSION_NODE *p_left, CEXPRESSION_NODE *p_right ) {
	CASSEMBLER_LINE asm_line;

	if( p_left->type == p_right->type ) {
		//	¶‰E‚Ì€‚ª“¯‚¶Œ^‚Ìê‡
		if( p_left->type == CEXPRESSION_TYPE::INTEGER ) {
			this->type = CEXPRESSION_TYPE::INTEGER;
		}
		else if( p_left->type == CEXPRESSION_TYPE::STRING ) {
			this->type = CEXPRESSION_TYPE::STRING;
		}
		else if( p_right->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
			p_info->assembler_list.add_label( "work_arg", "0x0f847" );
			p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
			p_info->assembler_list.activate_pop_single_real_dac();
			this->type = CEXPRESSION_TYPE::DOUBLE_REAL;	//	”{¸“x‚É¸Ši
			//	‰E€‚ð ARG ‚Ö
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_arg" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "4" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	¶€‚ð DAC ‚Ö
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+4]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+6]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			p_info->assembler_list.activate_pop_double_real_dac();
			this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
			p_info->assembler_list.add_label( "work_arg", "0x0f847" );
			p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
			//	‰E€‚ð ARG ‚Ö
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "work_arg" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	¶€‚ð DAC ‚Ö
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_double_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else if( p_left->type == CEXPRESSION_TYPE::STRING || p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	¶‰E‚Ì€‚ªˆÙ‚È‚éŒ^‚ÅA•Ð•û‚ª•¶Žš—ñŒ^‚È‚çƒGƒ‰[
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	else {
		//	”{¸“x‚ÅŒvŽZ‚·‚é‚Ì‚Å”{¸“x‚É¸Ši
		this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
		//	‰E€‚Í”{¸“x‚É‚µ‚Ä ARG ‚Ö“]‘—
		if( p_right->type == CEXPRESSION_TYPE::INTEGER ) {
			//	®”‚©‚ç”{¸“xŽÀ”‚É¸Ši
			p_info->assembler_list.add_label( "bios_maf", "0x02c4d" );
			p_info->assembler_list.add_label( "bios_frcdbl", "0x0303a" );
			p_info->assembler_list.add_label( "work_dac_int", "0x0f7f8" );
			p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_maf", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( p_right->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
			p_info->assembler_list.activate_ld_arg_single_real();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			p_info->assembler_list.activate_ld_arg_double_real();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}

		//	¶€‚Í”{¸“x‚É‚µ‚Ä DAC ‚Ö“]‘—
		if( p_left->type == CEXPRESSION_TYPE::INTEGER ) {
			//	®”‚©‚ç”{¸“xŽÀ”‚É¸Ši
			p_info->assembler_list.add_label( "bios_frcdbl", "0x0303a" );
			p_info->assembler_list.add_label( "work_dac_int", "0x0f7f8" );
			p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( p_left->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
			p_info->assembler_list.activate_pop_single_real_dac();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			p_info->assembler_list.activate_pop_double_real_dac();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_double_real_dac", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
}

// --------------------------------------------------------------------
void CEXPRESSION_NODE::convert_type( CCOMPILE_INFO *p_info, CEXPRESSION_TYPE target, CEXPRESSION_TYPE current ) {
	CASSEMBLER_LINE asm_line;

	if( target == current ) {
		return;
	}
	if( target == CEXPRESSION_TYPE::EXTENDED_INTEGER ) {
		if( current == CEXPRESSION_TYPE::INTEGER ) {
			//	•ÏŠ·‚Ì•K—v‚È‚µ
			return;
		}
		if( current == CEXPRESSION_TYPE::SINGLE_REAL ) {
			p_info->assembler_list.activate_convert_to_integer_from_sngle_real( &(p_info->constants) );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "convert_to_integer_from_sngle_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			return;
		}
		if( current == CEXPRESSION_TYPE::DOUBLE_REAL ) {
			p_info->assembler_list.activate_convert_to_integer_from_double_real( &(p_info->constants) );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "convert_to_integer_from_double_real", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			return;
		}
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}

	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	p_info->assembler_list.add_label( "work_dac_int", "0x0f7f8" );

	if( target == CEXPRESSION_TYPE::INTEGER ) {
		p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
		p_info->assembler_list.add_label( "bios_frcint", "0x02f8a" );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
		if( current == CEXPRESSION_TYPE::SINGLE_REAL ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "4" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" ); 
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "[work_dac+4]", COPERAND_TYPE::REGISTER, "BC" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "[work_dac+6]", COPERAND_TYPE::REGISTER, "BC" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" ); 
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "8" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcint", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( target == CEXPRESSION_TYPE::SINGLE_REAL ) {
		p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
		p_info->assembler_list.add_label( "bios_frcsng", "0x02fb2" );
		if( current == CEXPRESSION_TYPE::INTEGER ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "2" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcsng", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( current == CEXPRESSION_TYPE::DOUBLE_REAL ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::REGISTER, "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcsng", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else if( target == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
		p_info->assembler_list.add_label( "bios_frcdbl", "0x0303a" );
		if( current == CEXPRESSION_TYPE::INTEGER ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "2" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( current == CEXPRESSION_TYPE::SINGLE_REAL ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::REGISTER, "4" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "4" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else {
	}
}

// --------------------------------------------------------------------
bool CEXPRESSION::check_word( CCOMPILE_INFO *p_info, std::string s, int error_id ) {

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != s ) {
		if( error_id != CERROR_ID::NO_ERROR ) {
			p_info->errors.add( CERROR_ID( error_id ), p_info->list.get_line_no() );	//	‚ ‚é‚×‚«•Â‚¶Š‡ŒÊ
		}
		return false;
	}
	p_info->list.p_position++;
	return true;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_term( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	if( p_info->list.is_command_end() ) {
		return nullptr;															//	’l‚ª–³‚¢ê‡‚Í nullptr ‚ð•Ô‚·
	}
	s_operator = p_info->list.p_position->s_word;
	if( s_operator == "(" && p_info->list.p_position->type == CBASIC_WORD_TYPE::SYMBOL ) {
		p_info->list.p_position++;
		p_result = this->makeup_node_operator_eqv( p_info );
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" || p_info->list.p_position->type != CBASIC_WORD_TYPE::SYMBOL ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«•Â‚¶Š‡ŒÊ
			return p_result;
		}
		p_info->list.p_position++;
		return p_result;
	}
	else if( s_operator == "ABS" ) {
		CEXPRESSION_ABS *p_term = new CEXPRESSION_ABS;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "ASC" ) {
		CEXPRESSION_ASC *p_term = new CEXPRESSION_ASC;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "ATN" ) {
		CEXPRESSION_ATN *p_term = new CEXPRESSION_ATN;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "BIN$" ) {
		CEXPRESSION_BIN *p_term = new CEXPRESSION_BIN;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "CDBL" ) {
		CEXPRESSION_CDBL *p_term = new CEXPRESSION_CDBL;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "CHR$" ) {
		CEXPRESSION_CHR *p_term = new CEXPRESSION_CHR;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "CINT" ) {
		CEXPRESSION_CINT *p_term = new CEXPRESSION_CINT;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "COS" ) {
		CEXPRESSION_COS *p_term = new CEXPRESSION_COS;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "CSNG" ) {
		CEXPRESSION_CSNG *p_term = new CEXPRESSION_CSNG;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "CSRLIN" ) {
		CEXPRESSION_CSRLIN *p_term = new CEXPRESSION_CSRLIN;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( s_operator == "EXP" ) {
		CEXPRESSION_EXP *p_term = new CEXPRESSION_EXP;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "FIX" ) {
		CEXPRESSION_FIX *p_term = new CEXPRESSION_FIX;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "FRE" ) {
		CEXPRESSION_FRE *p_term = new CEXPRESSION_FRE;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "HEX$" ) {
		CEXPRESSION_HEX *p_term = new CEXPRESSION_HEX;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "INKEY$" ) {
		CEXPRESSION_INKEY *p_term = new CEXPRESSION_INKEY;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( s_operator == "INP" ) {
		CEXPRESSION_INP *p_term = new CEXPRESSION_INP;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "INT" ) {
		CEXPRESSION_INT *p_term = new CEXPRESSION_INT;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "INSTR" ) {
		CEXPRESSION_INSTR *p_term = new CEXPRESSION_INSTR;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand1 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ",", MISSING_OPERAND ) ) {
			return p_result;
		}
		p_term->p_operand2 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "LEFT$" ) {
		CEXPRESSION_LEFT *p_term = new CEXPRESSION_LEFT;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand1 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ",", MISSING_OPERAND ) ) {
			return p_result;
		}
		p_term->p_operand2 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "LEN" ) {
		CEXPRESSION_LEN *p_term = new CEXPRESSION_LEN;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "LOG" ) {
		CEXPRESSION_LOG *p_term = new CEXPRESSION_LOG;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "MID$" ) {
		CEXPRESSION_MID *p_term = new CEXPRESSION_MID;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand1 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ",", MISSING_OPERAND ) ) {
			return p_result;
		}
		p_term->p_operand2 = this->makeup_node_operator_eqv( p_info );
		p_term->p_operand3 = nullptr;
		if( this->check_word( p_info, ")", NO_ERROR ) ) {
			//	‘æ3ˆø”‚ªÈ—ª‚³‚ê‚Ä‚¢‚éê‡
			return p_result;
		}
		if( !this->check_word( p_info, ",", MISSING_OPERAND ) ) {
			return p_result;
		}
		p_term->p_operand3 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "OCT$" ) {
		CEXPRESSION_OCT *p_term = new CEXPRESSION_OCT;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "PAD" ) {
		CEXPRESSION_PAD *p_term = new CEXPRESSION_PAD;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "PEEK" ) {
		CEXPRESSION_PEEK *p_term = new CEXPRESSION_PEEK;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "RIGHT$" ) {
		CEXPRESSION_RIGHT *p_term = new CEXPRESSION_RIGHT;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand1 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ",", MISSING_OPERAND ) ) {
			return p_result;
		}
		p_term->p_operand2 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "RND" ) {
		CEXPRESSION_RND *p_term = new CEXPRESSION_RND;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "SGN" ) {
		CEXPRESSION_SGN *p_term = new CEXPRESSION_SGN;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "SIN" ) {
		CEXPRESSION_SIN *p_term = new CEXPRESSION_SIN;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "STICK" ) {
		CEXPRESSION_STICK *p_term = new CEXPRESSION_STICK;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "STRIG" ) {
		CEXPRESSION_STRIG *p_term = new CEXPRESSION_STRIG;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "STR$" ) {
		CEXPRESSION_STR *p_term = new CEXPRESSION_STR;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "STRING$" ) {
		CEXPRESSION_STRING *p_term = new CEXPRESSION_STRING;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand1 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ",", MISSING_OPERAND ) ) {
			return p_result;
		}
		p_term->p_operand2 = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "TAN" ) {
		CEXPRESSION_TAN *p_term = new CEXPRESSION_TAN;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "TIME" ) {
		CEXPRESSION_TIME *p_term = new CEXPRESSION_TIME;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( s_operator == "USR" ) {
		CEXPRESSION_USR *p_term = new CEXPRESSION_USR;
		p_result = p_term;
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			delete p_term;
			return nullptr;
		}
		if( p_info->list.p_position->s_word.size() == 1 && isdigit( p_info->list.p_position->s_word[0] & 255 ) ) {
			p_term->n = p_info->list.p_position->s_word[0] - '0';
			p_info->list.p_position++;
		}
		else {
			p_term->n = 0;
		}
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word.size() != 1 ) {
			p_term->type = CEXPRESSION_TYPE::INTEGER;
		}
		else if( p_info->list.p_position->s_word == "%" ) {
			p_term->type = CEXPRESSION_TYPE::INTEGER;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "!" ) {
			p_term->type = CEXPRESSION_TYPE::SINGLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "#" ) {
			p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "$" ) {
			p_term->type = CEXPRESSION_TYPE::STRING;
			p_info->list.p_position++;
		}
		return p_result;
	}
	else if( s_operator == "VAL" ) {
		CEXPRESSION_VAL *p_term = new CEXPRESSION_VAL;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "VARPTR" ) {
		CEXPRESSION_VARPTR *p_term = new CEXPRESSION_VARPTR;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_position = p_info->list.p_position;
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "#" ) {
			//	VARPTR( #1 ) ‚Ì‚æ‚¤‚ÈŽg‚¢•û‚Ìê‡
			p_info->list.p_position++;
			if( p_info->list.is_command_end() ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				return p_result;
			}
			int n = std::stoi( p_info->list.p_position->s_word );
			if( n < 0 || n > 15 ) {
				p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
				return p_result;
			}
			p_term->file_number = n;
			p_info->list.p_position++;
		}
		else {
			//	VARPTR( A ) ‚Ì‚æ‚¤‚ÈŽg‚¢•û‚Ìê‡
			p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		}
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "VDP" ) {
		CEXPRESSION_VDP *p_term = new CEXPRESSION_VDP;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( s_operator == "VPEEK" ) {
		CEXPRESSION_VPEEK *p_term = new CEXPRESSION_VPEEK;
		p_result = p_term;
		p_info->list.p_position++;
		if( !this->check_word( p_info, "(", SYNTAX_ERROR ) ) {
			delete p_term;
			return nullptr;
		}
		p_term->p_operand = this->makeup_node_operator_eqv( p_info );
		if( !this->check_word( p_info, ")", MISSING_OPERAND ) ) {
			return p_result;
		}
		return p_result;
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	•Ï”‚Ìê‡
		CEXPRESSION_VARIABLE *p_term = new CEXPRESSION_VARIABLE;
		CVARIABLE variable = p_info->variable_manager.get_variable_info( p_info, p_term->exp_list );
		p_term->variable = variable;
		p_result = p_term;
		return p_result;
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::INTEGER ) {
		//	®”’è”‚Ìê‡
		CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM;
		p_term->type = CEXPRESSION_TYPE::INTEGER;
		p_term->s_value = s_operator;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::SINGLE_REAL ) {
		//	’P¸“xŽÀ”’è”‚Ìê‡
		CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM;
		p_term->type = CEXPRESSION_TYPE::SINGLE_REAL;
		p_term->s_value = s_operator;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::DOUBLE_REAL ) {
		//	”{¸“xŽÀ”’è”‚Ìê‡
		CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM;
		p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
		p_term->s_value = s_operator;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::STRING ) {
		//	•¶Žš—ñ’è”‚Ìê‡
		CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM;
		p_term->type = CEXPRESSION_TYPE::STRING;
		p_term->s_value = s_operator;
		p_result = p_term;
		p_info->list.p_position++;
		return p_result;
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
	}
	else if( s_operator == ":" || s_operator == "," ) {
		return nullptr;
	}
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return nullptr;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_power( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_POWER *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_term( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "^" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_POWER;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_term( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_minus_plus( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_OPERATOR_MINUS *p_operator_minus;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	if( p_info->list.is_command_end() ) {
		return nullptr;
	}
	s_operator = p_info->list.p_position->s_word;
	if( (s_operator != "+" && s_operator != "-") || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
		//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢
		return this->makeup_node_operator_power( p_info );
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
		return nullptr;
	}
	//	‚±‚Ì‰‰ŽZŽq‚Ìˆ—
	if( s_operator == "+" ) {
		//	+ ‚ÍŽÀŽ¿‰½‚à‚µ‚È‚¢
		return this->makeup_node_operator_minus_plus( p_info );
	}
	else {
		//	if( s_operator == "-" )
		p_operator_minus = new CEXPRESSION_OPERATOR_MINUS;
		p_operator_minus->p_right = this->makeup_node_operator_minus_plus( p_info );
		p_result = p_operator_minus;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_mul_div( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_MUL *p_operator_mul;
	CEXPRESSION_OPERATOR_DIV *p_operator_div;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_minus_plus( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( (s_operator != "*" && s_operator != "/") || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		if( s_operator == "*" ) {
			p_operator_mul = new CEXPRESSION_OPERATOR_MUL;
			p_operator_mul->p_left = p_result;
			p_operator_mul->p_right = this->makeup_node_operator_minus_plus( p_info );
			p_result = p_operator_mul;
		}
		else {
			//	if( s_operator == "-" )
			p_operator_div = new CEXPRESSION_OPERATOR_DIV;
			p_operator_div->p_left = p_result;
			p_operator_div->p_right = this->makeup_node_operator_minus_plus( p_info );
			p_result = p_operator_div;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_intdiv( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_INTDIV *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_mul_div( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "\\" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_INTDIV;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_mul_div( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_mod( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_MOD *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_intdiv( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "MOD" ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_MOD;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_intdiv( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_add_sub( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_ADD *p_operator_add;
	CEXPRESSION_OPERATOR_SUB *p_operator_sub;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_mod( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( (s_operator != "+" && s_operator != "-") || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		if( s_operator == "+" ) {
			p_operator_add = new CEXPRESSION_OPERATOR_ADD;
			p_operator_add->p_left = p_result;
			p_operator_add->p_right = this->makeup_node_operator_mod( p_info );
			p_result = p_operator_add;
		}
		else {
			//	if( s_operator == "-" )
			p_operator_sub = new CEXPRESSION_OPERATOR_SUB;
			p_operator_sub->p_left = p_result;
			p_operator_sub->p_right = this->makeup_node_operator_mod( p_info );
			p_result = p_operator_sub;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_compare( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_EQU *p_operator_equ;
	CEXPRESSION_OPERATOR_NEQ *p_operator_neq;
	CEXPRESSION_OPERATOR_GT *p_operator_gt;
	CEXPRESSION_OPERATOR_GE *p_operator_ge;
	CEXPRESSION_OPERATOR_LT *p_operator_lt;
	CEXPRESSION_OPERATOR_LE *p_operator_le;
	CEXPRESSION_NODE *p_result;
	std::string s_operator, s_operator2;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_add_sub( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( (s_operator != "=" && s_operator != "<" && s_operator != ">") || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		s_operator2 = p_info->list.p_position->s_word;
		if( s_operator2 == "=" || s_operator2 == "<" || s_operator2 == ">" ) {
			//	<>, ><, >=, =>, <=, =< ‚Ìê‡A2‚Â‚Ì’PŒê‚É•ª‚©‚ê‚Ä‚é‚Ì‚Å“‡‚·‚é
			s_operator = s_operator + s_operator2;
			p_info->list.p_position++;
			if( p_info->list.is_command_end() ) {
				p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
				break;
			}
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		if( s_operator == "=" ) {
			p_operator_equ = new CEXPRESSION_OPERATOR_EQU;
			p_operator_equ->p_left = p_result;
			p_operator_equ->p_right = this->makeup_node_operator_add_sub( p_info );
			p_result = p_operator_equ;
		}
		else if( s_operator == "<>" || s_operator == "><" ) {
			p_operator_neq = new CEXPRESSION_OPERATOR_NEQ;
			p_operator_neq->p_left = p_result;
			p_operator_neq->p_right = this->makeup_node_operator_add_sub( p_info );
			p_result = p_operator_neq;
		}
		else if( s_operator == ">" ) {
			p_operator_gt = new CEXPRESSION_OPERATOR_GT;
			p_operator_gt->p_left = p_result;
			p_operator_gt->p_right = this->makeup_node_operator_add_sub( p_info );
			p_result = p_operator_gt;
		}
		else if( s_operator == "<" ) {
			p_operator_lt = new CEXPRESSION_OPERATOR_LT;
			p_operator_lt->p_left = p_result;
			p_operator_lt->p_right = this->makeup_node_operator_add_sub( p_info );
			p_result = p_operator_lt;
		}
		else if( s_operator == ">=" || s_operator == "=>" ) {
			p_operator_ge = new CEXPRESSION_OPERATOR_GE;
			p_operator_ge->p_left = p_result;
			p_operator_ge->p_right = this->makeup_node_operator_add_sub( p_info );
			p_result = p_operator_ge;
		}
		else { 
			//	if( s_operator == "<=" || s_operator == "=<" )
			p_operator_le = new CEXPRESSION_OPERATOR_LE;
			p_operator_le->p_left = p_result;
			p_operator_le->p_right = this->makeup_node_operator_add_sub( p_info );
			p_result = p_operator_le;
		}
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_not( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_OPERATOR_NOT *p_operator;
	std::string s_operator;

	s_operator = p_info->list.p_position->s_word;
	if( s_operator != "NOT" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
		//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å‰E€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
		return this->makeup_node_operator_compare( p_info );
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
		return nullptr;
	}
	//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
	p_operator = new CEXPRESSION_OPERATOR_NOT;
	p_operator->p_right = this->makeup_node_operator_not( p_info );
	return p_operator;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_and( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_AND *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_not( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "AND" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_AND;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_not( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_or( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_OR *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_and( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "OR" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_OR;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_and( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_xor( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_XOR *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_or( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "XOR" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_XOR;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_or( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_imp( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_IMP *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_xor( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "IMP" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_IMP;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_xor( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
CEXPRESSION_NODE *CEXPRESSION::makeup_node_operator_eqv( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p_left;
	CEXPRESSION_OPERATOR_EQV *p_operator;
	CEXPRESSION_NODE *p_result;
	std::string s_operator;

	//	¶€‚ð“¾‚é
	p_left = this->makeup_node_operator_imp( p_info );
	if( p_left == nullptr ) {
		return nullptr;				//	¶€‚ª“¾‚ç‚ê‚È‚©‚Á‚½ê‡
	}
	p_result = p_left;
	while( !p_info->list.is_command_end() ) {
		s_operator = p_info->list.p_position->s_word;
		if( s_operator != "EQV" || p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD ) {
			//	Š–]‚Ì‰‰ŽZŽq‚Å‚Í‚È‚¢‚Ì‚Å¶€‚ð‚»‚Ì‚Ü‚Ü•Ô‚·
			break;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );	//	‚ ‚é‚×‚«‰E€‚ª‚È‚¢
			break;
		}
		//	‚±‚Ì‰‰ŽZŽq‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚ð¶¬
		p_operator = new CEXPRESSION_OPERATOR_EQV;
		p_operator->p_left = p_result;
		p_operator->p_right = this->makeup_node_operator_imp( p_info );
		p_result = p_operator;
	}
	return p_result;
}

// --------------------------------------------------------------------
void CEXPRESSION::makeup_node( CCOMPILE_INFO *p_info ) {

	if( this->p_top_node != nullptr ) {
		//	Šù‚Éƒm[ƒh¶¬Ï‚Ý‚È‚ç‰½‚à‚µ‚È‚¢
		return;
	}

	this->p_top_node = this->makeup_node_operator_eqv( p_info );

	if( this->p_top_node != nullptr && p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY ) {
		//	Node Only ˆÈã‚ÌÅ“K‰»ƒŒƒxƒ‹‚ªŽw’è‚³‚ê‚Ä‚¢‚éê‡ANODE ‚ÌÅ“K‰»‚ðŽÀŽ{‚·‚éB
		this->p_top_node->optimization( p_info );
	}
}

// --------------------------------------------------------------------
bool CEXPRESSION::compile( CCOMPILE_INFO *p_info, CEXPRESSION_TYPE target ) {

	this->makeup_node( p_info );
	if( this->p_top_node == nullptr ) {
		return false;
	}
	this->p_top_node->compile( p_info );
	if( target == this->p_top_node->type || target == CEXPRESSION_TYPE::UNKNOWN ) {
		//	Œ^‚ªˆê’v‚µ‚Ä‚¢‚éê‡‚ÆA•ÏŠ·–³‚µ‚ªŽw’è‚³‚ê‚Ä‚¢‚éê‡‚ÍAŒ^•ÏŠ·•s—v
		return true;
	}
	//	Œ^•ÏŠ·
	if( target != CEXPRESSION_TYPE::STRING ) {
		if( this->p_top_node->type == CEXPRESSION_TYPE::STRING ) {
			//	”’lŒ^‚ð—v‹‚µ‚Ä‚¢‚é‚Ì‚É•¶Žš—ñŒ^‚ªŽw’è‚³‚ê‚Ä‚¢‚éê‡
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return false;
		}
		//	”’lŒ^‚Ìê‡
		this->p_top_node->convert_type( p_info, target, this->p_top_node->type );
	}
	else {
		//	•¶Žš—ñŒ^‚ð—v‹‚µ‚Ä‚¢‚é‚Ì‚É”’lŒ^‚ªŽw’è‚³‚ê‚Ä‚¢‚éê‡
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return false;
	}
	return true;
}
