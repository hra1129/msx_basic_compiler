// --------------------------------------------------------------------
//	Compiler collection: Close
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "close.h"
#include "../expressions/expression.h"
#include "../expressions/expression_term.h"

// --------------------------------------------------------------------
//  CLOSE �t�@�C�������
bool CCLOSE::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "CLOSE" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->use_file_access = true;
	if( p_info->list.is_command_end() ) {
		//	���������̏ꍇ�A�S�Ẵt�@�C�������
		p_info->assembler_list.activate_all_close();
		asm_line.set( "CALL", "", "sub_all_close" );
		return true;
	}

	for( ;; ) {
		//	# ������Γǂݔ�΂�
		if( p_info->list.p_position->s_word == "#" ) {
			if( p_info->list.p_position->type != CBASIC_WORD_TYPE::SYMBOL ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				return true;
			}
			p_info->list.p_position++;
		}
		//	�ԍ���]��
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			exp.release();
			p_info->assembler_list.activate_close();
			asm_line.set( "CALL", "", "sub_close" );
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		//	, ��������ΏI���
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->s_word != "," || p_info->list.p_position->type != CBASIC_WORD_TYPE::SYMBOL ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}
	return true;
}
