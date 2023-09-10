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
//  COLOR �F�w��
//  COLOR <�O�i�F>, <�w�i�F>, <���ӐF>
bool CCOLOR::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
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

	if( p_info->list.is_command_end() ) {
		//	COLOR�P�Ǝ��s�̏ꍇ
		p_info->assembler_list.add_label( "bios_iniplt", "0x00141" );
		p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "bios_iniplt" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_extrom", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->s_word == "=" ) {
		//	COLOR= �̏ꍇ
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		if( p_info->list.p_position->s_word == "NEW" ) {
			//	COLOR=NEW �̏ꍇ
			p_info->assembler_list.add_label( "bios_iniplt", "0x00141" );
			p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "bios_iniplt" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_extrom", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "RESTORE" ) {
			//	COLOR=RESTORE �̏ꍇ
			p_info->assembler_list.add_label( "bios_rstplt", "0x00145" );
			p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "bios_rstplt" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_extrom", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "(" ) {
			//	COLOR=(P,R,G,B) �̏ꍇ
			p_info->list.p_position++;




		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		}
		return true;
	}

	//	��1���� <�O�i�F>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
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
	if( p_info->list.p_position->s_word != "," ) {
		if( has_parameter ) {
			//	��1�����݂̂̏ꍇ
			put_call( p_info );
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		}
		return true;
	}
	p_info->list.p_position++;
	//	��2���� <�w�i�F>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
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
			//	COLOR x, �̂悤�ɑ������܂łő��������ȗ�����Ă���ꍇ
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
	//	��3���� <���ӐF>
	has_parameter = false;
	if( exp.compile( p_info ) ) {
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
			//	COLOR x, �̂悤�ɑ������܂łő��������ȗ�����Ă���ꍇ
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		else {
			put_call( p_info );
		}
		return true;
	}
	//	COLOR a, b, c d �̂悤�ɑ�O�����̎��ɕςȕ���������ꍇ
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return true;
}
