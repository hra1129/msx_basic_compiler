// --------------------------------------------------------------------
//	Compiler collection: Pset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "pset.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PSET (X,Y),C
bool CPSET::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp, exp_x, exp_y;
	bool is_preset = false;
	int line_no = p_info->list.get_line_no();
	std::string s_label1, s_label2;

	if( p_info->list.p_position->s_word != "PSET" && p_info->list.p_position->s_word != "PRESET" ) {
		return false;
	}
	is_preset = (p_info->list.p_position->s_word == "PRESET");

	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		//	PSET だけで終わってる場合は Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_pset", "0x057F5" );
	p_info->assembler_list.add_label( "bios_setatr", "0x0011A" );
	p_info->assembler_list.add_label( "subrom_setc", "0x009D" );
	p_info->assembler_list.add_label( "work_cloc", "0xF92A" );
	p_info->assembler_list.add_label( "work_cmask", "0xF92C" );
	p_info->assembler_list.add_label( "work_scrmod", "0xFCAF" );
	p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
	s_label1 = p_info->get_auto_label();
	s_label2 = p_info->get_auto_label();

	//	X座標
	exp_x.makeup_node( p_info );
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	Y座標
	exp_y.makeup_node( p_info );
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")"){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	PSET(x,y) の場合
		//	ロジカルオペレーションは PSET固定
		p_info->assembler_list.add_label( "work_logopr", "0x0fB02" );
		asm_line.set( "XOR", "", "A", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_logopr]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		//	色は PSET なら前景色に、PRESET なら背景色になる
		if( is_preset ) {
			p_info->assembler_list.add_label( "work_bakclr", "0x0F3EA" );
			asm_line.set( "LD", "", "A", "[work_bakclr]" );
		}
		else {
			p_info->assembler_list.add_label( "work_forclr", "0x0F3E9" );
			asm_line.set( "LD", "", "A", "[work_forclr]" );
		}
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_setatr" );
		p_info->assembler_list.body.push_back( asm_line );
		//	X座標
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( "LD", "", "[work_cloc]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		//	Y座標
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( "LD", "", "[work_cmask]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "BC", "[work_cloc]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "A", "[work_scrmod]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CP", "", "A", "5" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "JR", "NC", s_label1 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_pset" );		//	SCREEN2,3,4
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "JR", "", s_label2 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LABEL", "", s_label1 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "IX", "subrom_setc" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_extrom" );		//	SCREEN5～
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EI" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LABEL", "", s_label2 );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	色
	if( p_info->list.is_command_end() ) {
		//	PSET(x,y), で終わってるのでエラー
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		asm_line.set( "LD", "", "A", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_setatr" );
		p_info->assembler_list.body.push_back( asm_line );
		//	ロジカルオペレーション
		p_info->p_compiler->put_logical_operation();
		//	X座標
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( "LD", "", "[work_cloc]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		//	Y座標
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( "LD", "", "[work_cmask]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "BC", "[work_cloc]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "A", "[work_scrmod]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CP", "", "A", "5" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "JR", "NC", s_label1 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_pset" );		//	SCREEN2,3,4
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "JR", "", s_label2 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LABEL", "", s_label1 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "IX", "subrom_setc" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_extrom" );		//	SCREEN5～
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EI" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LABEL", "", s_label2 );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		return true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->errors.add( SYNTAX_ERROR, line_no );
	return true;
}
