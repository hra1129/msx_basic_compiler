// --------------------------------------------------------------------
//	Compiler collection: Vpoke
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------

#include "vpoke.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  VPOKE <アドレス>, <値>
bool CVPOKE::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "VPOKE" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	std::string s_label1, s_label2;
	//	第1引数 <アドレス>
	if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
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

		p_info->assembler_list.add_label( "bios_wrtvrm", "0x004d" );
		p_info->assembler_list.add_label( "bios_nwrvrm", "0x0177" );
		p_info->assembler_list.add_label( "work_scrmod", "0xFCAF" );

		s_label1 = p_info->get_auto_label();
		s_label2 = p_info->get_auto_label();

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[work_scrmod]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "5" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::CONSTANT, s_label1, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_wrtvrm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label2, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label1, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_nwrvrm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label2, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	return true;
}
