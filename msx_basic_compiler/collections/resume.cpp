// --------------------------------------------------------------------
//	Compiler collection: Resume
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------

#include "resume.h"

// --------------------------------------------------------------------
//  RESUME            エラーを起こした文を再実行
//  RESUME 0          同上
//  RESUME NEXT       エラーを起こした文の次の文から再開
//  RESUME <行番号>   指定行へジャンプ
//	再実行/次文のアドレスは、トラップ時に待避した文レコード
//	(error_raised の指す {行番号, 再実行アドレス, 次文アドレス})
//	から取り出す。いずれも「ハンドラ内」フラグを解除してから飛ぶ。
bool CRESUME::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "RESUME" ) {
		return false;
	}
	p_info->list.p_position++;
	p_info->use_on_error = true;

	//	ハンドラ内フラグの解除 (全形式共通)
	asm_line.set( "LD", "", "A", "0" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[svarb_error_in_handler]", "A" );
	p_info->assembler_list.body.push_back( asm_line );

	if( p_info->list.is_command_end() ) {
		//	RESUME (再実行)
		asm_line.set( "LD", "", "HL", "[svari_error_raised]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "DE", "2" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( p_info->list.p_position->s_word == "NEXT" ) {
		//	RESUME NEXT
		p_info->list.p_position++;
		asm_line.set( "LD", "", "HL", "[svari_error_raised]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "DE", "4" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
		if( p_info->list.p_position->s_word == "0" ) {
			//	RESUME 0 は RESUME と同じ (再実行)
			p_info->list.p_position++;
			asm_line.set( "LD", "", "HL", "[svari_error_raised]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "2" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( p_info->list.p_position->s_word[0] == '*' ) {
			asm_line.set( "JP", "", "label_" + p_info->list.p_position->s_word.substr(1) );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
			return true;
		}
		else {
			asm_line.set( "JP", "", "line_" + p_info->list.p_position->s_word );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
			return true;
		}
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	//	レコード +2 (再実行) / +4 (次文) のアドレスへ飛ぶ
	asm_line.set( "ADD", "", "HL", "DE" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "JP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
