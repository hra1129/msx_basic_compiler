// --------------------------------------------------------------------
//	Compiler collection: Poke
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------

#include "poke.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  POKE <アドレス>, <値>
bool CPOKE::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "POKE" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	//	第1引数 <アドレス>
	if( exp.compile( p_info ) ) {
		asm_line.type = CMNEMONIC_TYPE::PUSH;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 <値>
	if( exp.compile( p_info ) ) {
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::MEMORY_CONSTANT;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "[HL]";
		asm_line.operand1.type = COPERAND_TYPE::MEMORY_REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	return true;
}
