// --------------------------------------------------------------------
//	Compiler collection: LineInput
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------

#include "lineinput.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  LINE INPUT ["<プロンプト>";] <文字列変数>
//  LINE INPUT #<ファイル番号>, <文字列変数>
//	キーボード形は BIOS の INLIN による行編集を使う (実機の LINE INPUT
//	が持つ画面編集とは細部が異なる近似)。ファイル形は INPUT# と同じ
//	読み取り基盤 (_fi_getc) の上に乗り、行全体 (カンマやコロンを含む)
//	をそのまま文字列変数へ入れる。
bool CLINEINPUT::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	CVARIABLE variable;

	if( p_info->list.p_position->s_word != "LINE" ) {
		return false;
	}
	//	次の語が INPUT でなければ LINE 文として処理させない
	if( (p_info->list.p_position + 1)->s_word != "INPUT" ) {
		return false;
	}
	p_info->list.p_position += 2;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( p_info->list.p_position->s_word == "#" ) {
		//	ファイル形
		p_info->list.p_position++;
		p_info->assembler_list.activate_file_number();
		p_info->use_file_access = true;
		if( !exp.compile( p_info ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		exp.release();
		asm_line.set( "CALL", "", "sub_file_number" );
		p_info->assembler_list.body.push_back( asm_line );
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		variable = p_info->p_compiler->get_variable_address();
		if( variable.type != CVARIABLE_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, line_no );
			return true;
		}
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->assembler_list.activate_sub_line_input_file();
		asm_line.set( "CALL", "", "sub_line_input_file" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}

	//	キーボード形: 任意のプロンプト
	if( p_info->list.p_position->type == CBASIC_WORD_TYPE::STRING ) {
		CSTRING value;
		value.set( p_info->list.p_position->s_word );
		p_info->assembler_list.activate_puts();
		std::string s_label = p_info->constants.add( value );
		asm_line.set( "LD", "", "HL", s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "puts" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ";" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}

	variable = p_info->p_compiler->get_variable_address();
	if( variable.type != CVARIABLE_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, line_no );
		return true;
	}
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.activate_sub_line_input();
	asm_line.set( "CALL", "", "sub_line_input" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
