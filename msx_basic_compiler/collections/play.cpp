// --------------------------------------------------------------------
//	Compiler collection: Play
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------

#include "play.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PLAY <ch1>, <ch2>, <ch3>
bool CPLAY::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "PLAY" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	//	��1���� <Ch1>
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
		p_info->assembler_list.activate_free_string();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( p_info->list.is_command_end() || p_info->list.p_position->s_word == "," ) {
		//	��1���������́A�G���[
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	//	��1��������ŁA�R�}���h�G���h�͐���
	if( p_info->list.is_command_end() ) {
		return true;
	}
	else if( p_info->list.p_position->s_word != "," ) {
		//	��1��������ŁA�R�}���h�G���h�łȂ��� , �������ꍇ�̓G���[
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	��2���� <Ch2>
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
		p_info->assembler_list.activate_free_string();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( p_info->list.is_command_end() || p_info->list.p_position->s_word == "," ) {
		//	��2���������́A�G���[
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}
	//	��2��������ŁA�R�}���h�G���h�͐���
	if( p_info->list.is_command_end() ) {
		return true;
	}
	else if( p_info->list.p_position->s_word != "," ) {
		//	��2��������ŁA�R�}���h�G���h�łȂ��� , �������ꍇ�̓G���[
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;

	//	��3���� <Ch2>
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
		p_info->assembler_list.activate_free_string();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	��3���������́A�G���[
		p_info->errors.add( MISSING_OPERAND, p_info->list.get_line_no() );
		return true;
	}

	return true;
}
