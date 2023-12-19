// --------------------------------------------------------------------
//	Compiler collection: Screen
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "screen.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SCREEN 画面モード指定
//  SCREEN <mode>, <SpriteSize>, <KeyClick>, <BaudRate>, <PrinterType>, <InterlaceMode>
bool CSCREEN::exec( CCOMPILE_INFO *p_info ) {
	bool has_parameter;
	int line_no = p_info->list.get_line_no();
	std::string s_label1;
	std::string s_label2;

	if( p_info->list.p_position->s_word != "SCREEN" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	//	第1引数 <mode>
	has_parameter = false;
	if( exp.compile( p_info ) ) {

		p_info->assembler_list.add_label( "work_romver", "0x0002D" );
		p_info->assembler_list.add_label( "bios_chgmod", "0x0005F" );		//	パレットの初期化無し
		p_info->assembler_list.add_label( "bios_chgmodp", "0x001B5" );		//	パレットの初期化あり
		p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
		s_label1 = p_info->get_auto_label();
		s_label2 = p_info->get_auto_label();
		//	MSX2以上では BASIC の SCREEN 命令で画面モードを切り替えるとパレットを初期化するため、chgmodp の方を呼ぶ必要がある
		//	chgmodp は、SUB-ROM に存在するため、MSX1 では chgmod を呼ぶ必要あり。
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[work_romver]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::CONSTANT, s_label1, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_chgmod", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label2, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label1, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::CONSTANT, "bios_chgmodp" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_extrom", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EI" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label2, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第2引数 <SpriteSize>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "work_rg1sv", "0x0f3e0" );
		p_info->assembler_list.add_label( "bios_wrtvdp", "0x00047" );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::AND, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "3" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[work_rg1sv]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::AND, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xFC" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::CONSTANT, "1" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_wrtvdp", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第3引数 <KeyClick>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "work_cliksw", "0x0f3db" );
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "[work_cliksw]";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第4引数 <BaudRate>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "work_cs1200", "0x0f3fc" );
		p_info->assembler_list.add_label( "work_cs2400", "0x0f401" );
		p_info->assembler_list.add_label( "work_low", "0x0f406" );
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::DEC;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::AND;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "1";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "work_cs1200";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		std::string s_label = p_info->get_auto_label();
		asm_line.type = CMNEMONIC_TYPE::JR;
		asm_line.condition = CCONDITION::Z;
		asm_line.operand1.s_value = s_label;
		asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.condition = CCONDITION::NONE;

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "HL";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "work_cs2400";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LABEL;
		asm_line.operand1.s_value = s_label;
		asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "DE";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "work_low";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "BC";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "5";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LDIR;
		asm_line.operand1.s_value = "";
		asm_line.operand1.type = COPERAND_TYPE::NONE;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第5引数 <PrinterType>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "work_ntmsxp", "0x0f417" );
		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "[work_ntmsxp]";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_parameter ) {
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	第6引数 <InterlaceMode>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "work_rg9sv", "0x0ffe8" );
		p_info->assembler_list.add_label( "bios_wrtvdp", "0x00047" );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::AND;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "3";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::ADD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::ADD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "L";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "[work_rg9sv]";
		asm_line.operand2.type = COPERAND_TYPE::MEMORY;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::AND;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "0xF3";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::OR;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "B";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "C";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "9";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::CALL;
		asm_line.operand1.s_value = "bios_wrtvdp";
		asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_parameter = true;
	}
	if( !has_parameter ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
	}
	return true;
}
