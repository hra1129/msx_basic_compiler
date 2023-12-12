// --------------------------------------------------------------------
//	Compiler collection: Line
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "line.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  LINE [(SX,SY)]-[STEP](EX,EY),C [,{B|BF}]
bool CLINE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp, exp_x, exp_y;
	bool has_step = false;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "LINE" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	LINE だけで終わってる場合は Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	p_info->assembler_list.add_label( "work_gxpos", "0x0FCB3" );
	p_info->assembler_list.add_label( "work_gypos", "0x0FCB5" );
	p_info->assembler_list.add_label( "work_grpacx", "0x0FCB7" );
	p_info->assembler_list.add_label( "work_grpacy", "0x0FCB9" );
	p_info->assembler_list.add_label( "work_scrmod", "0x0FCAF" );
	p_info->assembler_list.add_label( "bios_line", "0x058FC" );
	p_info->assembler_list.add_label( "bios_lineb", "0x05912" );
	p_info->assembler_list.add_label( "bios_linebf", "0x058C1" );
	p_info->assembler_list.add_label( "bios_setatr", "0x0011A" );

	if( p_info->list.p_position->s_word == "(" ) {
		//	始点座標の指定がある場合
		//	(
		p_info->list.p_position++;
		//	X座標
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_grpacx]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		//	,
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		//	Y座標
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_grpacy]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		//	)
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}
	//	-
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "-" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	STEP
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "STEP" ) {
		has_step = true;
		p_info->list.p_position++;
	}
	//	(
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
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
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	,
	if( p_info->list.is_command_end() ) {
		//	LINE (x,y)-(x,y) で終わってる場合。線を描く。
		//	ロジカルオペレーションは PSET固定
		p_info->assembler_list.add_label( "work_logopr", "0x0fB02" );
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_logopr]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		//	色は前景色になる
		p_info->assembler_list.add_label( "work_forclr", "0x0F3E9" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_forclr]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_setatr", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_line", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->s_word != "," ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	//	色
	if( p_info->list.p_position->s_word != "," ){
		//	ロジカルオペレーションは PSET固定
		p_info->assembler_list.add_label( "work_logopr", "0x0fB02" );
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_logopr]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		//	色の指定がある
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_setatr", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			//	LINE (x,y)-(x,y),c で終わってる場合。線を描く。
			if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
			if( has_step ) {
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
			if( has_step ) {
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_line", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
	}
	//	,
	if( p_info->list.p_position->s_word != "," ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	B または BF
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word == "B" ) {
		//	B の場合
		p_info->list.p_position++;
		//	ロジカルオペレーション
		p_info->p_compiler->put_logical_operation();
		//	LINE (x,y)-(x,y),c,b で終わってる場合。塗りつぶし四角を描く。
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_lineb", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	else if( p_info->list.p_position->s_word == "BF" ) {
		p_info->assembler_list.add_label( "work_romver", "0x0002D" );
		p_info->assembler_list.add_label( "bios_nvbxfl", "0x000CD" );
		p_info->assembler_list.add_label( "bios_extrom", "0x0015F" );
		//	BF の場合
		p_info->list.p_position++;
		//	ロジカルオペレーション
		p_info->p_compiler->put_logical_operation();
		//	LINE (x,y)-(x,y),c,bf で終わってる場合。塗りつぶし四角を描く。
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		std::string s_label1 = p_info->get_auto_label();
		std::string s_label2 = p_info->get_auto_label();

		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_scrmod]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "5" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::LABEL, s_label1, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_linebf", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label2, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NZ, COPERAND_TYPE::LABEL, s_label1, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "bios_nvbxfl" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_extrom", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NZ, COPERAND_TYPE::LABEL, s_label2, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	else if( p_info->list.p_position->s_word == "," ) {
		//	ロジカルオペレーション
		p_info->p_compiler->put_logical_operation();
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( has_step ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_line", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	p_info->errors.add( SYNTAX_ERROR, line_no );
	return true;
}
