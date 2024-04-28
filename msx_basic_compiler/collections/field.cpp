// --------------------------------------------------------------------
//	Compiler collection: Field
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "field.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  FIELD #n, サイズ AS 文字列変数名 [, サイズ AS 文字列変数名 ...]
//
bool CFIELD::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	int var_count;
	std::string s_blank;

	if( p_info->list.p_position->s_word != "FIELD" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "#" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	p_info->assembler_list.activate_string();
	p_info->assembler_list.activate_file_number();
	p_info->assembler_list.activate_field();
	p_info->use_file_access = true;

	//	#n の n
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	asm_line.set( "CALL", "", "sub_file_number" );
	p_info->assembler_list.body.push_back( asm_line );
	exp.release();
	asm_line.set( "LD", "", "DE", "37" );					//	FCB をスキップするためのオフセット
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "DE" );
	p_info->assembler_list.body.push_back( asm_line );
	var_count = 0;
	do {
		//	,
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;
		asm_line.set( "PUSH", "", "HL" );						//	(1) FILE INFO 内の変数アドレスリストのアドレスを保存
		p_info->assembler_list.body.push_back( asm_line );
		//	サイズ
		if( !exp.compile( p_info ) ) {							//	サイズの数値を評価して HL に格納
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		exp.release();
		//	AS
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "AS" ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;

		asm_line.set( "LD", "", "A", "L" );						//	A = 文字数
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "DE" );						//	[1] FILE INFO 内の変数アドレスリストのアドレスを復帰
		p_info->assembler_list.body.push_back( asm_line );
		//	変数
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
			//	変数名では無い
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		CVARIABLE variable = p_info->p_compiler->get_variable_address();				//	HL = 変数のアドレス
		if( variable.dimension != 0 || variable.type != CVARIABLE_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return true;
		}
		//	FILE INFO にサイズ・変数アドレスを書き込む
		asm_line.set( "CALL", "", "sub_field" );					//	HL = 変数のアドレス, DE = 変数アドレスリストのアドレス
		p_info->assembler_list.body.push_back( asm_line );

	} while( !p_info->list.is_command_end() && var_count < 16 );

	if( var_count < 16 ) {
		//	16個未満だった場合は、端末コードをセットする
		asm_line.set( "LD", "", "[HL]", "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( !p_info->list.is_command_end() ) {
		//	16個だったら、FIELD命令の記述が終わってることも確かめる。終わってなければ、SUBSCRIPT_OUT_OF_RANGE を出す。
		p_info->errors.add( SUBSCRIPT_OUT_OF_RANGE, p_info->list.get_line_no() );
		return true;
	}
	return true;
}
