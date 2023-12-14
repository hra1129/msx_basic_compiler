// --------------------------------------------------------------------
//	Compiler collection: Locate
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "locate.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  LOCATE <X>, <Y>, <CURSOR>
bool CLOCATE::exec( CCOMPILE_INFO *p_info ) {
	bool has_parameter;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	std::string s_label;

	if( p_info->list.p_position->s_word != "LOCATE" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_posit", "0x000C6" );
	p_info->assembler_list.add_label( "work_csry", "0x0F3DC" );
	p_info->assembler_list.add_label( "work_csrx", "0x0F3DD" );
	p_info->assembler_list.add_label( "work_csrsw", "0x0FCA9" );
	p_info->assembler_list.add_label( "work_prtflg", "0x0f416" );

	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );

	CEXPRESSION exp;
	//	第1引数 <X>
	has_parameter = false;
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[work_csry]" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			//	LOCATE だけではエラー。
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_posit", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 <Y>
	has_parameter = false;
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_posit", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			//	LOCATE x, のように第二引数までで第二引数が省略されている場合はエラー
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	第3引数 <カーソルスイッチ>
	has_parameter = false;
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x1B" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "0x78" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		s_label = p_info->get_auto_label();
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::CONSTANT, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x35" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			//	LOCATE x,y, のように第三引数までで第三引数が省略されている場合はエラー
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	//	LOCATE a, b, c d のように第三引数の次に変な文字がある場合
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return true;
}
