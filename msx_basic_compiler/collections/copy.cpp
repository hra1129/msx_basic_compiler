// --------------------------------------------------------------------
//	Compiler collection: Copy
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "copy.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------t
bool CCOPY::get_x3_y3( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();

	p_info->assembler_list.add_label( "work_dx", "0xf566" );
	p_info->assembler_list.add_label( "work_dy", "0xf568" );
	p_info->assembler_list.add_label( "work_lop", "0xf570" );
	p_info->assembler_list.add_label( "work_acpage", "0x0faf6" );

	//	(
	p_info->list.p_position++;

	//	X3
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_dx]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	//	Y3
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_dy]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( p_info->list.is_command_end() ) {
		//	�]����F�`��y�[�W
		asm_line.set( "LD", "", "A", "[work_acpage]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_dy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		//	���W�J���I�y���[�V����
		p_info->p_compiler->put_logical_operation( true );
		return true;
	}
	//	,
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	�]����y�[�W
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "A", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_dy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		asm_line.set( "LD", "", "A", "[work_acpage]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_dy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	���W�J���I�y���[�V����
	p_info->p_compiler->put_logical_operation( true );
	return true;
}

// --------------------------------------------------------------------
//  (1) COPY <�t�@�C����> TO <�t�@�C����>
//  (2) COPY <�t�@�C����> TO <�z��ϐ���>
//  (3) COPY <�t�@�C����>[,<����>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//
//  (4) COPY <�z��ϐ���> TO <�t�@�C����>
//  (5) COPY <�z��ϐ���>[,<����>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//
//  (6) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//  (7) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <�t�@�C����>
//  (8) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <�z��ϐ���>
//
bool CCOPY::exec( CCOMPILE_INFO *p_info ) {
	CVARIABLE variable;
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp, exp_direction;
	bool has_direction;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "COPY" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		//	COPY �����ŏI����Ă�ꍇ�̓G���[
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word == "(" ) {
		//	( X1, Y1 )-[STEP]( X2, Y2 ), [�y�[�W] �������ꍇ
		//	��T.B.D.
		return true;
	}

	//	��1���������ɔz��ϐ��ƌ��Ȃ��ď��𓾂Ă݂�
	variable = p_info->variable_manager.get_array_info( p_info );
	if( variable.s_name == "" ) {
		//	�z��ϐ��ł͂Ȃ������ꍇ�A�t�@�C�����łȂ���΂Ȃ�Ȃ�
		if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
			asm_line.set( "PUSH", "", "HL" );
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
			//	�����̎w�肪����ꍇ
			p_info->list.p_position++;
			has_direction = true;
			exp_direction.makeup_node( p_info );
		}
		//	TO
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TO" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "(" ) {
			if( !this->get_x3_y3( p_info ) ) {
				//	�G���[�����������̂ŉ��������ɖ߂�
				return true;
			}
			//	(3) COPY <�t�@�C����>[,<����>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
			//	��T.B.D.
		}
		else {
			//	(1) COPY <�t�@�C����> TO <�t�@�C����>
			p_info->assembler_list.add_label( "work_buf", "0x0F55E" );

			if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
				p_info->assembler_list.activate_free_string();
				//	�����̎w��͖�������
				exp_direction.release();
				p_info->assembler_list.add_label( "blib_copy_file_to_file", "0x040ab" );

				asm_line.set( "POP", "", "DE" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "EX", "", "DE", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "PUSH", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "PUSH", "", "DE" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "BC", "[heap_next]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[work_buf + 0]", "BC" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "BC", "[heap_end]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[work_buf + 2]", "BC" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "IX", "blib_copy_file_to_file" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "call_blib" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "free_string" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "free_string" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
		}
	}
	else {
		//	�z��ϐ�������
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "," ) {
			//	�����̎w�肪����ꍇ
			p_info->list.p_position++;
			has_direction = true;
			exp_direction.makeup_node( p_info );
		}
		//	TO
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TO" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "(" ) {
			if( !this->get_x3_y3( p_info ) ) {
				//	�G���[�����������̂ŉ��������ɖ߂�
				return true;
			}
			//	(5) COPY <�z��ϐ���>[,<����>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
		}
		else {
			//	(4) COPY <�z��ϐ���> TO <�t�@�C����>
			if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
				//	�����̎w��͖�������
				exp_direction.release();

			}
			else {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
		}
	}
	
	
	
	
	return true;
}
