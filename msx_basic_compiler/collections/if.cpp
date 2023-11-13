// --------------------------------------------------------------------
//	Compiler collection: If
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "if.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  IF 条件式 {THEN ステートメント|THEN 行番号|GOTO 行番号} [{ELSE ステートメント|ELSE 行番号}]
bool CIF::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	std::string s_end_label;
	std::string s_false_label;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "IF" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	//	条件式
	s_end_label		= p_info->get_auto_label();
	s_false_label	= p_info->get_auto_label();
	if( exp.compile( p_info, CEXPRESSION_TYPE::UNKNOWN ) ) {
		if( exp.get_type() == CEXPRESSION_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return true;
		}
		if( exp.get_type() == CEXPRESSION_TYPE::INTEGER ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( exp.get_type() == CEXPRESSION_TYPE::SINGLE_REAL ) {
			p_info->assembler_list.activate_single_real_is_zero();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "single_real_is_zero", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( exp.get_type() == CEXPRESSION_TYPE::DOUBLE_REAL ) {
			p_info->assembler_list.activate_double_real_is_zero();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "double_real_is_zero", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::Z, COPERAND_TYPE::LABEL, s_false_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word == "GOTO" ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else if( p_info->list.p_position->s_word == "THEN" ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			//	THEN で終わる場合。この場合は何もしないだけでエラーでは無い。
		}
		else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
			//	行番号の場合
			asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
		}
		else {
			//	ステートメントの場合
			p_info->p_compiler->line_compile();
			asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_end_label, COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	ELSE
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_false_label, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	if( p_info->list.is_line_end() ) {
		//	ELSE は無い
	}
	if( p_info->list.p_position->s_word == "ELSE" ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			//	THEN で終わる場合。この場合は何もしないだけでエラーでは無い。
		}
		else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
			//	行番号の場合
			asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + p_info->list.p_position->s_word, COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
		}
		else {
			//	ステートメントの場合
			p_info->p_compiler->line_compile();
		}
	}
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_end_label, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
