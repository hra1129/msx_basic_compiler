// --------------------------------------------------------------------
//	Compiler collection: On Stop
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "on_stop.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//	STOP {ON|OFF|STOP}
void CONSTOP::stop( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return;
	}

	if( p_info->list.p_position->s_word == "OFF" || p_info->list.p_position->s_word == "STOP" ) {
		asm_line.set( "XOR", "", "A", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[svarb_on_stop_mode]",  "A" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		p_info->use_on_stop = true;
	}
	else if( p_info->list.p_position->s_word == "ON" ) {
		asm_line.set( "LD", "", "A", "1" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[svarb_on_stop_mode]",  "A" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		p_info->use_on_stop = true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
	}
}

// --------------------------------------------------------------------
//  ON STOP GOSUB <飛び先>
bool CONSTOP::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word == "STOP" ) {
		//	STOP {ON|OFF|STOP}
		this->stop( p_info );
		return true;
	}
	if( p_info->list.p_position->s_word != "ON" ) {
		return false;
	}
	//	ON STOP GOSUB line
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word != "STOP" ) {
		p_info->list.p_position--;
		return false;
	}
	p_info->list.p_position++;

	//	飛び先
	if( p_info->list.p_position->s_word != "GOSUB" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	//	行番号の記述がない場合はエラー
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
		if( p_info->list.p_position->s_word[0] == '*' ) {
			asm_line.set( "LD", "", "HL", "label_" + p_info->list.p_position->s_word.substr(1) );
		}
		else {
			asm_line.set( "LD", "", "HL", "line_" + p_info->list.p_position->s_word );
		}
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[svari_on_stop_line]",  "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->use_on_stop = true;
	return true;
}
