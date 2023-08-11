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
	bool has_parameter = false;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "SCREEN" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_chgmod", "0x0005F" );
	p_info->assembler_list.add_label( "bios_chgmodp", "0x001B5" );
	p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );

	CEXPRESSION exp;
	//	第1引数 <mode>
	if( exp.compile( p_info ) ) {
		CASSEMBLER_LINE asm_line;
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
	//	第2引数 <SpriteSize>
	//	第3引数 <KeyClick>
	//	第4引数 <BaudRate>
	//	第5引数 <PrinterType>
	//	第6引数 <InterlaceMode>
	//	引数チェック
	if( !has_parameter ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
	}
	return true;
}
