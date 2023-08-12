// --------------------------------------------------------------------
//	Compiler collection: Out
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "out.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  OUT <I/Oポート番号>, <書き込む値>
bool COUT::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	bool has_parameter;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "OUT" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	//	第1引数 <I/Oポート番号>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		asm_line.type = CMNEMONIC_TYPE::PUSH;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		exp.release();
		has_parameter = true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 <書き込む値>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		asm_line.type = CMNEMONIC_TYPE::POP;
		asm_line.operand1.s_value = "BC";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}

	asm_line.type = CMNEMONIC_TYPE::OUT;
	asm_line.operand1.s_value = "[C]";
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand2.s_value = "L";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
