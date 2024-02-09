// --------------------------------------------------------------------
//	Compiler collection: Mid$
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "mid.h"
#include "../expressions/expression.h"
#include "../expressions/expression_variable.h"

// --------------------------------------------------------------------
//  MID$( 変数名, 置換開始位置 [, 置換サイズ] ) = 置換文字列
bool CMID::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "MID$" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		p_info->list.p_position--;
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.activate_copy_string();
	p_info->assembler_list.activate_free_string();
	//	変数のアドレスを得て、その内容をコピーに置き換える
	std::vector< CBASIC_WORD >::const_iterator p_position_back = p_info->list.p_position;
	CVARIABLE variable = p_info->p_compiler->get_variable_address();
	asm_line.set( "LD", "", "E", "[HL]" );					//	DE = 変数に格納されている文字列のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );					//	変数に入ってる文字列のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );					//	変数のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string", "" );			//	変数に入ってる文字列をコピーする
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "DE" );						//	変数のアドレスを取得
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );					//	HL=変数のアドレス, DE=コピーした文字列のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );					//	変数の中身を、コピーした文字列に置き換える
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );						//	変数に入っていた文字列のアドレスを取得
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );				//	解放
	p_info->assembler_list.body.push_back( asm_line );

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
		//	第2引数の処理
		asm_line.set( "LD", "", "B", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		//	第3引数の処理
		asm_line.set( "PUSH", "", "BC" );
		p_info->assembler_list.body.push_back( asm_line );
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( "POP", "", "BC" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "C", "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "PUSH", "", "BC" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
	}
	else {
		//	第3引数が省略されている場合
		asm_line.set( "LD", "", "C", "255" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "PUSH", "", "BC" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "=" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	//	= の右側の式を処理
	exp.makeup_node( p_info );

	bool is_compatible_mode = false;
	if( p_info->options.compile_mode == CCOMPILE_MODE::COMPATIBLE && exp.get_top_node() != nullptr && exp.get_top_node()->is_variable ) {
		is_compatible_mode = true;
		CEXPRESSION_VARIABLE *p = reinterpret_cast<CEXPRESSION_VARIABLE*>(exp.get_top_node());
		p->no_copy = true;
	}
	if( ! exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );

	//	ここの時点で、「代入先の文字列変数に入ってる文字列のアドレス」「代入先の文字列配列変数」
	//	のアドレスが変わっている可能性がある。従って、ここでまた変数の内容を取り直す。
	std::vector< CBASIC_WORD >::const_iterator p_position_next = p_info->list.p_position;
	p_info->list.p_position = p_position_back;
	variable = p_info->p_compiler->get_variable_address();
	p_info->list.p_position = p_position_next;
	asm_line.set( "LD", "", "E", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );

	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "BC" );
	p_info->assembler_list.body.push_back( asm_line );
	if( !is_compatible_mode ) {
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.add_label( "blib_mid_cmd", "0x0406c" );
	asm_line.set( "LD", "", "IX", "blib_mid_cmd" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	if( !is_compatible_mode ) {
		asm_line.set( "POP", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "free_string" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	exp.release();
	return true;
}
