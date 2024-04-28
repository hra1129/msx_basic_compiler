// --------------------------------------------------------------------
//	Compiler collection: Field
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "field.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  FIELD #n, �T�C�Y AS ������ϐ��� [, �T�C�Y AS ������ϐ��� ...]
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

	//	#n �� n
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	asm_line.set( "CALL", "", "sub_file_number" );
	p_info->assembler_list.body.push_back( asm_line );
	exp.release();
	asm_line.set( "LD", "", "DE", "37" );					//	FCB ���X�L�b�v���邽�߂̃I�t�Z�b�g
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
		asm_line.set( "PUSH", "", "HL" );						//	(1) FILE INFO ���̕ϐ��A�h���X���X�g�̃A�h���X��ۑ�
		p_info->assembler_list.body.push_back( asm_line );
		//	�T�C�Y
		if( !exp.compile( p_info ) ) {							//	�T�C�Y�̐��l��]������ HL �Ɋi�[
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

		asm_line.set( "LD", "", "A", "L" );						//	A = ������
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "DE" );						//	[1] FILE INFO ���̕ϐ��A�h���X���X�g�̃A�h���X�𕜋A
		p_info->assembler_list.body.push_back( asm_line );
		//	�ϐ�
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
			//	�ϐ����ł͖���
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		CVARIABLE variable = p_info->p_compiler->get_variable_address();				//	HL = �ϐ��̃A�h���X
		if( variable.dimension != 0 || variable.type != CVARIABLE_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return true;
		}
		//	FILE INFO �ɃT�C�Y�E�ϐ��A�h���X����������
		asm_line.set( "CALL", "", "sub_field" );					//	HL = �ϐ��̃A�h���X, DE = �ϐ��A�h���X���X�g�̃A�h���X
		p_info->assembler_list.body.push_back( asm_line );

	} while( !p_info->list.is_command_end() && var_count < 16 );

	if( var_count < 16 ) {
		//	16�����������ꍇ�́A�[���R�[�h���Z�b�g����
		asm_line.set( "LD", "", "[HL]", "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( !p_info->list.is_command_end() ) {
		//	16��������AFIELD���߂̋L�q���I����Ă邱�Ƃ��m���߂�B�I����ĂȂ���΁ASUBSCRIPT_OUT_OF_RANGE ���o���B
		p_info->errors.add( SUBSCRIPT_OUT_OF_RANGE, p_info->list.get_line_no() );
		return true;
	}
	return true;
}
