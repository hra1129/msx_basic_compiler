// --------------------------------------------------------------------
//	Compiler collection: DefUsr
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "defusr.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  DEFUSR<�ԍ�>=<�A�h���X>
bool CDEFUSR::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	CEXPRESSION exp;
	int usr_num;

	if( p_info->list.p_position->s_word != "DEF" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "USR" ) {
		//	DEF �����ŏI����Ă�ꍇ�� Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::INTEGER ) {
		//	DEF �����ŏI����Ă�ꍇ�� Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->assembler_list.add_label( "work_usrtab", "0x0f39a" );
	usr_num = stoi( p_info->list.p_position->s_word );
	if( usr_num < 0 || usr_num > 9 ) {
		//	DEFUSRn �� n �� 0�`9 �łȂ��ꍇ�� Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "=" ) {
		//	DEFUSRn �̌�� = �������ꍇ�� Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
		exp.release();
	}
	else {
		//	DEFUSRn= �̌�Ɏ��������ꍇ�� Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL, "[work_usrtab + " + std::to_string(usr_num * 2) + "]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
