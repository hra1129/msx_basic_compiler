// --------------------------------------------------------------------
//	Compiler collection: Open
// ====================================================================
//	2024/Mar/26th	t.hara
// --------------------------------------------------------------------

#include "open.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  OPEN <�t�@�C����> [FOR {INPUT|OUTPUT|APPEND}] AS #<�t�@�C���ԍ�> [LEN=<���R�[�h��>]
bool COPEN::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	int for_type;

	if( p_info->list.p_position->s_word != "OPEN" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	//	��1���� <�t�@�C����>
	p_info->use_file_access = true;
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	if( p_info->list.is_command_end() || (p_info->list.p_position->s_word != "FOR" && p_info->list.p_position->s_word != "AS") ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	FOR �`
	if( p_info->list.p_position->s_word == "FOR" ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		if( p_info->list.p_position->s_word == "INPUT" ) {
			p_info->list.p_position++;
			for_type = 0;
		}
		else if( p_info->list.p_position->s_word == "OUTPUT" ) {
			p_info->list.p_position++;
			for_type = 1;
		}
		else if( p_info->list.p_position->s_word == "APPEND" ) {
			p_info->list.p_position++;
			for_type = 2;
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
	}
	else {
		for_type = 3;
	}
	//	AS
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "AS" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	//	��2���� #<�t�@�C���ԍ�>
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "#" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	exp.release();
	if( for_type != 3 ) {
		//	FOR INPUT, OUTPUT, APPEND �̏ꍇ�͂����Ŋm��
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		switch( for_type ) {
		default:
		case 0:		//	FOR INPUT
			p_info->assembler_list.activate_open_for_input();
			asm_line.set( "CALL", "", "sub_open_for_input" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		case 1:		//	FOR OUTPUT
			p_info->assembler_list.activate_open_for_output();
			asm_line.set( "CALL", "", "sub_open_for_output" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		case 2:		//	FOR APPEND
			p_info->assembler_list.activate_open_for_append();
			asm_line.set( "CALL", "", "sub_open_for_append" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
	}
	//	FOR�̎w�肪�����ꍇ�́A#n �̌�� LEN �̎w�肪���邩�m�F����
	if( p_info->list.is_command_end() ) {
		//	AS #n �ŏI����Ă���̂� LEN = 256 �Ɣ��f����
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "XOR", "", "A", "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	LEN = n �����邩�`�F�b�N����
		if( p_info->list.p_position->s_word != "LEN" ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "=" ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;
		asm_line.set( "PUSH", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp.compile( p_info ) ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		exp.release();
		asm_line.set( "LD", "", "A", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	p_info->assembler_list.activate_open_for_none();
	asm_line.set( "CALL", "", "sub_open_for_none" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
