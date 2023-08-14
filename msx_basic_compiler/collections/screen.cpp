// --------------------------------------------------------------------
//	Compiler collection: Screen
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "screen.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  SCREEN ‰æ–Êƒ‚[ƒhw’è
//  SCREEN <mode>, <SpriteSize>, <KeyClick>, <BaudRate>, <PrinterType>, <InterlaceMode>
bool CSCREEN::exec( CCOMPILE_INFO *p_info ) {
	bool has_parameter;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "SCREEN" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	//	‘æ1ˆø” <mode>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		if( p_info->options.target_type == CTARGET_TYPES::MSX1 ) {
			p_info->assembler_list.add_label( "bios_chgmod", "0x0005F" );
		}
		else {
			p_info->assembler_list.add_label( "bios_chgmodp", "0x001B5" );
			p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
		}

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "L";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		if( p_info->options.target_type == CTARGET_TYPES::MSX1 ) {
			asm_line.type = CMNEMONIC_TYPE::CALL;
			asm_line.operand1.s_value = "bios_chgmod";
			asm_line.operand1.type = COPERAND_TYPE::LABEL;
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.type = CMNEMONIC_TYPE::LD;
			asm_line.operand1.s_value = "IX";
			asm_line.operand1.type = COPERAND_TYPE::REGISTER;
			asm_line.operand2.s_value = "bios_chgmodp";
			asm_line.operand2.type = COPERAND_TYPE::LABEL;
			p_info->assembler_list.body.push_back( asm_line );

			asm_line.type = CMNEMONIC_TYPE::CALL;
			asm_line.operand1.s_value = "bios_extrom";
			asm_line.operand1.type = COPERAND_TYPE::LABEL;
			p_info->assembler_list.body.push_back( asm_line );
		}
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
	//	‘æ2ˆø” <SpriteSize>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
		p_info->assembler_list.add_label( "work_rg1sv", "0x0f3e0" );
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

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "L";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "A";
		asm_line.operand2.type = COPERAND_TYPE::REGISTER;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "[work_rg1sv]";
		asm_line.operand2.type = COPERAND_TYPE::MEMORY_CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::AND;
		asm_line.operand1.s_value = "A";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "0xFC";
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
		asm_line.operand2.s_value = "1";
		asm_line.operand2.type = COPERAND_TYPE::CONSTANT;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::CALL;
		asm_line.operand1.s_value = "bios_wrtvdp";
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
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
	//	‘æ3ˆø” <KeyClick>
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
	//	‘æ4ˆø” <BaudRate>
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
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
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
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
		asm_line.operand2.s_value = "";
		asm_line.operand2.type = COPERAND_TYPE::NONE;
		p_info->assembler_list.body.push_back( asm_line );

		asm_line.type = CMNEMONIC_TYPE::LD;
		asm_line.operand1.s_value = "DE";
		asm_line.operand1.type = COPERAND_TYPE::REGISTER;
		asm_line.operand2.s_value = "work_low";
		asm_line.operand2.type = COPERAND_TYPE::LABEL;
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
	//	‘æ5ˆø” <PrinterType>
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
	//	‘æ6ˆø” <InterlaceMode>
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
		asm_line.operand2.type = COPERAND_TYPE::MEMORY_CONSTANT;
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
		asm_line.operand1.type = COPERAND_TYPE::LABEL;
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
