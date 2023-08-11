// --------------------------------------------------------------------
//	Compiler collection: Color
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "color.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
static void put_call( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	asm_line.type = CMNEMONIC_TYPE::CALL;
	asm_line.operand1.s_value = "bios_chgclr";
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	p_info->assembler_list.body.push_back( asm_line );
}

// --------------------------------------------------------------------
//  COLOR 色指定
//  COLOR <前景色>, <背景色>, <周辺色>
bool CCOLOR::exec( CCOMPILE_INFO *p_info ) {
	bool has_parameter;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "COLOR" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_chgclr", "0x00062" );
	p_info->assembler_list.add_label( "work_forclr", "0x0F3E9" );
	p_info->assembler_list.add_label( "work_bakclr", "0x0F3EA" );
	p_info->assembler_list.add_label( "work_bdrclr", "0x0F3EB" );

	CEXPRESSION exp;
	//	第1引数 <前景色>
	has_parameter = false;
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
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			//	COLOR単独実行の場合
			//	★ T.B.D.
		}
		else {
			put_call( p_info );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 <背景色>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		CASSEMBLER_LINE asm_line;
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "[work_bakclr]";
		asm_line.operand1.type = COPERAND_TYPE::MEMORY_CONSTANT;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			//	COLOR x, のように第二引数までで第二引数が省略されている場合
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		else {
			put_call( p_info );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第3引数 <周辺色>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		CASSEMBLER_LINE asm_line;
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "[work_bdrclr]";
		asm_line.operand1.type = COPERAND_TYPE::MEMORY_CONSTANT;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			//	COLOR x, のように第二引数までで第二引数が省略されている場合
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		else {
			put_call( p_info );
		}
		return true;
	}
	//	COLOR a, b, c d のように第三引数の次に変な文字がある場合
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return true;
}
