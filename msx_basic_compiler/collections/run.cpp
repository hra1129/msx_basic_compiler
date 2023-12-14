// --------------------------------------------------------------------
//	Compiler collection: Run
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "run.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  RUN [行番号]
bool CRUN::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	std::string s_label;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "RUN" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		//	RUN 単独の実行の場合
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "program_start" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "program_run", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
		//	RUN {行番号} の実行の場合
		if( p_info->list.p_position->s_word[0] == '*' ) {
			s_label = "label_" + p_info->list.p_position->s_word.substr(1);
		}
		else {
			s_label = "line_" + p_info->list.p_position->s_word;
		}
		p_info->list.p_position++;
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "program_run", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	//	RUN ファイル名 の実行の場合
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
	}
	p_info->assembler_list.activate_bload_r();
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_bload_r", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );

	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word != "R" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}

	return true;
}
