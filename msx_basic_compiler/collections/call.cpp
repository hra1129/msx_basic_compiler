// --------------------------------------------------------------------
//	Compiler collection: Call
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "call.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
void CCALL::iot_set_device_path( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;

	//	IOTGET のサブルーチンが無ければ追加する: HL=デバイスパスのアドレス
	if( p_info->assembler_list.is_registered_subroutine( "iot_set_device_path" ) ) {
		return;
	}
	p_info->assembler_list.add_label( "bios_errhand", "0x0406F" );
	p_info->assembler_list.add_subroutines( "iot_set_device_path" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "iot_set_device_path", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::CONSTANT, "8" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	//	デバイスパス送信開始コマンド
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xE0" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "1" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x53" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	//	デバイスパス送信
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xC0" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	//	文字列長を調べる ----------------------------------
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );	//	A = Length
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iot_set_device_path_loop1", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "A", COPERAND_TYPE::CONSTANT, "64" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, "_iot_set_device_path_skip", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SUB, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "A", COPERAND_TYPE::CONSTANT, "63" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x7F" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iot_set_device_path_skip", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "B" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x3F" );	//	0～63 はそのまま。0x7F は 63 に。
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iot_set_device_path_loop2", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[C]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iot_set_device_path_loop2", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "D" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SUB, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "A", COPERAND_TYPE::CONSTANT, "63" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_iot_set_device_path_exit", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::LABEL, "_iot_set_device_path_loop1", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iot_set_device_path_exit", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[C]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RLCA, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NC, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::NONE, "E", COPERAND_TYPE::NONE, "13" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::NONE, "bios_errhand", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCALL::iot_get_integer( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;

	//	IOTGET のサブルーチンが無ければ追加する: HL=デバイスパスのアドレス
	if( p_info->assembler_list.is_registered_subroutine( "iot_get_integer" ) ) {
		return;
	}
	p_info->assembler_list.add_label( "bios_errhand", "0x0406F" );
	p_info->assembler_list.add_subroutines( "iot_get_integer" );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xE0" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x01" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	// 整数型識別コード送信
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x01" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	// 受信開始
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x80" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[8]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::MEMORY_CONSTANT, "[8]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::MEMORY_CONSTANT, "[8]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCALL::iot_get_string( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;

	//	IOTGET のサブルーチンが無ければ追加する: HL=デバイスパスのアドレス
	if( p_info->assembler_list.is_registered_subroutine( "iot_get_string" ) ) {
		return;
	}
	p_info->assembler_list.activate_allocate_string();
	p_info->assembler_list.add_label( "bios_errhand", "0x0406F" );
	p_info->assembler_list.add_subroutines( "iot_get_string" );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "iotget_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	// 受信コマンド送信
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xE0" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x01" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	// 文字列型識別コード送信
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x03" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	// 受信開始
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x80" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[8]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[8]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::Z, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iotget_string_loop", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[8]" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_iotget_string_loop", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCALL::iotget( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return;
	}
	this->iot_set_device_path( p_info );
	//	第1引数: デバイスパス
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "iot_set_device_path", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
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
	//	第2引数: 値を受け取る変数名






	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	}
}

// --------------------------------------------------------------------
//  CALL 拡張命令
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
	//	非対応の命令
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return true;
}
