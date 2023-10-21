// --------------------------------------------------------------------
//	Compiler collection: Put Sprite
// ====================================================================
//	2023/Oct/21st	t.hara
// --------------------------------------------------------------------

#include "put_sprite.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PUT <スプライト番号>, ( <X座標>, <Y座標> ), <色>, <パターン番号>
bool CPUTSPRITE::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	bool has_xy_parameter = false;
	bool has_color_parameter = false;
	bool has_pattern_parameter = false;

	if( p_info->list.p_position->s_word != "PUT" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.p_position->s_word != "SPRITE" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	//	第1引数 <スプライト番号>
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
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
	//	第2引数 ( <X座標>, <Y座標> )
	if( p_info->list.p_position->s_word == "(" ) {
		p_info->list.p_position++;
		if( exp.compile( p_info ) ) {
			//	X座標
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
		if( exp.compile( p_info ) ) {
			//	Y座標
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;
		has_xy_parameter = true;
	}
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		if( exp.compile( p_info ) ) {
			//	色
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		has_color_parameter = true;
	}
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		if( exp.compile( p_info ) ) {
			//	パターン
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		has_pattern_parameter = true;
	}
	if( !has_xy_parameter && !has_color_parameter && !has_pattern_parameter ) {
		//	パラメータが一つも無い場合はエラー
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	処理を呼び出す
	int active_flag = 0;
	p_info->assembler_list.add_label( "blib_putsprite", "0x04045" );
	if( has_pattern_parameter ) {
		//	-- パターン番号
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		active_flag = 2;
	}
	if( has_color_parameter ) {
		//	-- 色
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::NONE, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		active_flag |= 4;
	}
	if( has_xy_parameter ) {
		//	-- Y座標
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	-- X座標
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::NONE, "C" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::NONE, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		active_flag |= 1;
	}
	//	-- スプライト番号
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	//	-- パラメーター省略フラグ
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::NONE, std::to_string( active_flag ) );
	p_info->assembler_list.body.push_back( asm_line );
	//	-- 呼び出し
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "ix", COPERAND_TYPE::LABEL, "blib_putsprite" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
