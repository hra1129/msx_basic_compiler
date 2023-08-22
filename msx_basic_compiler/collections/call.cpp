// --------------------------------------------------------------------
//	Compiler collection: Call
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "call.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
void CCALL::iotget( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;

	//	IOTGET �̃T�u���[�`����������Βǉ�����: HL=�f�o�C�X�p�X�̃A�h���X
	if( !p_info->assembler_list.is_registered_subroutine( "iot_set_device_path" ) ) {
		p_info->assembler_list.add_subroutines( "iot_set_device_path" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::NONE, "8" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::CONSTANT, "0xE0" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::CONSTANT, "1" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::CONSTANT, "0x53" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::CONSTANT, "0xC0" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "B" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "B", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "B", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::Z, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iotget_loop", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iotget_loop", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "B" );	//	B=0
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[C]" );
		p_info->assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::MEMORY_REGISTER, "" );
		p_info->assembler_list.subroutines.push_back( asm_line );
	}

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return;
	}
	//	��1����: �f�o�C�X�p�X
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return;
	}
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return;
	}
	//	��2����: �l���󂯎��ϐ���






	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	}
}

// --------------------------------------------------------------------
//  CALL �g������
bool CCALL::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "CALL" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word != "IOTGET" ) {
		this->iotget( p_info );
		return true;
	}
	//	��Ή��̖���
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return true;
}
