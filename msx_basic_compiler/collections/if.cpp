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
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "IF" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	//	条件式
	if( exp.compile( p_info ) ) {
		CASSEMBLER_LINE asm_line;
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "[work_forclr]";
		asm_line.operand1.type = COPERAND_TYPE::MEMORY_CONSTANT;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word == "GOTO" ) {
		p_info->list.p_position++;



	}
	else if( p_info->list.p_position->s_word == "THEN" ) {
		p_info->list.p_position++;



	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	ELSE
	if( p_info->list.is_command_end() ) {
		//	ELSE は無い
		return true;
	}
	if( p_info->list.p_position->s_word == "ELSE" ) {
		p_info->list.p_position++;



	}
	return true;
}
