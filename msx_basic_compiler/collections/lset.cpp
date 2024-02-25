// --------------------------------------------------------------------
//	Compiler collection: Lset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "lset.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LSET] {変数名}[(配列要素, 配列要素 ...)] = 式
bool CLSET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool is_rset = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word != "LSET" && p_info->list.p_position->s_word != "RSET" ) {
		return false;
	}
	is_rset = ( p_info->list.p_position->s_word == "RSET" );
	p_info->list.p_position++;
	
	//	変数を生成する
	CVARIABLE variable = p_info->p_compiler->get_variable_address();
	p_info->assembler_list.activate_allocate_string();
	p_info->assembler_list.activate_free_string();
	asm_line.set( "PUSH", "", "HL", "" );					//	HL = 変数のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );					//	DE = 元の文字列
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[DE]" );					//	A = 元の文字列の長さ
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "AF", "" );					//	元の文字列の長さを保存
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );					//	HL = 元の文字列
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string", "" );			//	元の文字列を解放
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "AF", "" );					//	元の文字列の長さを復帰
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_string", "" );		//	HL = 結果の格納先を確保
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );					//	DE = 変数のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );					//	HL = 変数のアドレス, DE = 結果の格納先
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );					//	HL = 変数のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );					//	変数に結果の格納先を保存
	p_info->assembler_list.body.push_back( asm_line );

	//	= のチェック
	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		// エラーは、check_word の中で登録される
		return true;
	}
	else if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	右辺の処理
	if( variable.type != CVARIABLE_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return true;
	}
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}

	asm_line.set( "POP", "", "DE", "" );				//	DE = 変数のアドレス
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );			//	HL = 変数のアドレス, DE = 右辺
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );				//	右辺保存
	p_info->assembler_list.body.push_back( asm_line );

	if( is_rset ) {
		p_info->assembler_list.add_label( "blib_rset", "0x04078" );
		asm_line.set( "LD", "", "IX", "blib_rset" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib", "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->assembler_list.add_label( "blib_lset", "0x04075" );
		asm_line.set( "LD", "", "IX", "blib_lset" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib", "" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	asm_line.set( "POP", "", "HL", "" );				//	右辺復帰
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string", "" );		//	元の文字列を解放
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
