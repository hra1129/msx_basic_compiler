// --------------------------------------------------------------------
//	Compiler collection: Let
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "let.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LET] {�ϐ���}[(�z��v�f, �z��v�f ...)] = ��
bool CLET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word == "LET" ) {
		p_info->list.p_position++;
		if( p_info->list.is_end() || p_info->list.p_position->line_no != line_no ) {
			//	LET �����ŏI����Ă�ꍇ�� Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		has_let = true;
	}
	
	if( p_info->list.p_position->s_word == "TIME" ) {
		//	TIME�V�X�e���ϐ��ւ̑��
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "=" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
			p_info->assembler_list.add_label( "work_jiffy", "0x0fc9e" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_jiffy]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
	}
	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	�ϐ����ł͖����̂ő���ł͖���
		if( has_let ) {
			//	LET �����ŏI����Ă�ꍇ�� Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		return false;
	}
	//	�ϐ��𐶐�����


	return true;
}
