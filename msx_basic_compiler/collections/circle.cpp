// --------------------------------------------------------------------
//	Compiler collection: Circle
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "circle.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  CIRCLE [STEP] (X, Y), 半径 [,カラーコード[,開始角度[,終了角度[,比率]]]]
bool CCIRCLE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	bool is_step = false;
	int line_no = p_info->list.get_line_no();
	bool has_parameter = false;

	if( p_info->list.p_position->s_word != "CIRCLE" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->list.p_position--;
		return false;
	}
	//	STEP
	if( p_info->list.p_position->s_word == "STEP" ) {
		is_step = true;
		p_info->list.p_position++;
	}
	//	(
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "work_gxpos", "0x0FCB3" );
	p_info->assembler_list.add_label( "work_gypos", "0x0FCB5" );
	p_info->assembler_list.add_label( "work_aspect", "0x0F931" );		//	比率 single real
	p_info->assembler_list.add_label( "work_cxoff", "0x0F945" );		//	水平半径
	p_info->assembler_list.add_label( "work_cyoff", "0x0F947" );		//	垂直半径
	p_info->assembler_list.add_label( "work_cpcnt", "0x0F939" );		//	開始点 single real
	p_info->assembler_list.add_label( "work_crcsum", "0x0F93D" );		//	終了点 single real
	p_info->assembler_list.add_label( "bios_setatr", "0x0011A" );

	//	X座標
	if( exp.compile( p_info ) ) {
		exp.release();
		if (is_step) {
			asm_line.set( "LD", "", "DE", "[work_gxpos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "ADD", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( "LD", "", "[work_circle_centerx]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	Y座標
	if( exp.compile( p_info ) ) {
		exp.release();
		if (is_step) {
			asm_line.set( "LD", "", "DE", "[work_gypos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "ADD", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_circle_centery]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	半径
	if( exp.compile( p_info ) ) {
		exp.release();
		asm_line.set( "LD", "", "[work_circle_radiusx]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	,
	has_parameter = false;
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	カラーコードがある場合
		if( exp.compile( p_info ) ) {
			has_parameter = true;
			exp.release();
			asm_line.set( "LD", "", "A", "L" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			has_parameter = false;
		}
	}
	if( !has_parameter ) {
		//	カラーコード省略
		p_info->assembler_list.add_label( "work_forclr", "0x0F3E9" );
		asm_line.set( "LD", "", "A", "[work_forclr]" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( "CALL", "", "bios_setatr" );
	p_info->assembler_list.body.push_back( asm_line );
	//	,
	has_parameter = false;
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	開始点がある場合
		if( exp.compile( p_info, CEXPRESSION_TYPE::SINGLE_REAL ) ) {
			has_parameter = true;
			exp.release();
			p_info->assembler_list.activate_ld_de_single_real();
			asm_line.set( "LD", "", "DE", "work_cpcnt" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "ld_de_single_real" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			has_parameter = false;
		}
	}
	if( !has_parameter ) {
		//	開始点省略
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_cpcnt + 0]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_cpcnt + 2]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	,
	has_parameter = false;
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	終了点がある場合
		if( exp.compile( p_info, CEXPRESSION_TYPE::SINGLE_REAL ) ) {
			has_parameter = true;
			exp.release();
			p_info->assembler_list.activate_ld_de_single_real();
			asm_line.set( "LD", "", "DE", "work_crcsum" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "ld_de_single_real" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			has_parameter = false;
		}
	}
	if( !has_parameter ) {
		//	終了点省略
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_crcsum + 0]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_crcsum + 2]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	,
	has_parameter = false;
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	比率がある場合
		if( exp.compile( p_info, CEXPRESSION_TYPE::SINGLE_REAL ) ) {
			has_parameter = true;
			exp.release();
			p_info->assembler_list.activate_ld_de_single_real();
			asm_line.set( "LD", "", "DE", "work_aspect" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "ld_de_single_real" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
	}
	if( !has_parameter ) {
		//	比率省略
		asm_line.set( "LD", "", "HL", "0x1041" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_aspect + 0]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_aspect + 2]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	p_info->assembler_list.activate_circle( p_info );
	asm_line.set( "CALL", "", "sub_circle" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
