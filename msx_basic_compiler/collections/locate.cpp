// --------------------------------------------------------------------
//	Compiler collection: Locate
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "locate.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  LOCATE <X>, <Y>, <CURSOR>
bool CLOCATE::exec( CCOMPILE_INFO *p_info ) {
	bool has_x, has_y;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	std::string s_label;

	if( p_info->list.p_position->s_word != "LOCATE" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "bios_posit", "0x000C6" );
	p_info->assembler_list.add_label( "work_csry", "0x0F3DC" );
	p_info->assembler_list.add_label( "work_csrx", "0x0F3DD" );
	p_info->assembler_list.add_label( "work_csrsw", "0x0FCA9" );
	p_info->assembler_list.add_label( "work_prtflg", "0x0f416" );

	CEXPRESSION exp;
	//	第1引数 <X>
	has_x = false;
	if( exp.compile( p_info ) ) {
		//	第1引数が存在した場合
		asm_line.set( "LD", "", "H", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "INC", "", "H" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_x = true;

		if( p_info->list.is_command_end() ) {
			//	LOCATE X の場合
			asm_line.set( "LD", "" "A", "[work_csry]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "" "L", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_posit" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}

		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	第1引数が省略されている場合
		asm_line.set( "LD", "" "A", "[work_csrx]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "" "H", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		if( p_info->list.is_command_end() ) {
			//	LOCATE : 引数が全くない場合
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
			return true;
		}
	}

	//	,
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	第2引数 <Y>
	has_y = false;
	if( exp.compile( p_info ) ) {
		//	第2引数が存在した場合
		if( !has_x ) {
			//	LOCATE ,Y : 第1引数は省略されていた場合
			asm_line.set( "LD", "" "A", "[work_csrx]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "" "H", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "" "L" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			//	LOCATE X, Y : 第1も第2も存在した場合
			asm_line.set( "LD", "", "A", "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "L", "A" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( "CALL", "", "bios_posit" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_y = true;
	}
	else {
		if( !has_x ) {
			//	LOCATE , : 第1引数も第2引数も省略されている場合
			if( p_info->list.is_command_end() ) {
				//	LOCATE , : 引数無しでカンマ1つで終わってる場合
				p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
				return true;
			}
			//	LOCATE , , ... : カーソル位置指定のパラメータがないため、posit 呼び出しは省略
		}
		else {
			//	LOCATE X, : 第2引数が省略されている場合
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "" "A", "[work_csry]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "" "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "" "L", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_posit" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}

	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		return true;
	}
	p_info->list.p_position++;

	//	第3引数 <カーソルスイッチ>
	has_x = false;
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "A", "0x1B" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "RST", "", "0x18", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "A", "0x78" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "INC", "", "L", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "DEC", "", "L", "" );
		p_info->assembler_list.body.push_back( asm_line );
		s_label = p_info->get_auto_label();
		asm_line.set( "JR", "Z", s_label, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "INC", "", "A", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LABEL", "", s_label, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "RST", "", "0x18", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "A", "0x35" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "RST", "", "0x18", "" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		has_x = true;
	}
	if( p_info->list.is_command_end() ) {
		if( !has_x ) {
			//	LOCATE x,y, のように第三引数までで第三引数が省略されている場合はエラー
			p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		}
		return true;
	}
	//	LOCATE a, b, c d のように第三引数の次に変な文字がある場合
	p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	return true;
}
