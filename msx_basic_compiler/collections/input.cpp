// --------------------------------------------------------------------
//	Compiler collection: Input
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "input.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  INPUT [ <文字列>; ] <変数名> [, <変数名> ... ]
bool CINPUT::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	std::vector< CASSEMBLER_LINE > assembler_list_buffer;

	if( p_info->list.p_position->s_word != "INPUT" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( p_info->list.p_position->type == CBASIC_WORD_TYPE::STRING ) {
		CSTRING value;
		value.set( p_info->list.p_position->s_word );
		p_info->assembler_list.activate_puts();
		std::string s_label = p_info->constants.add( value );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "puts", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ";" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}

	int variable_count = 0;
	size_t lines;
	int var_type;
	std::string s_data;
	while( !p_info->list.is_command_end() ) {
		//	assembler_list の現在位置を覚えておく
		lines = p_info->assembler_list.body.size();
		//	変数名を評価する
		CVARIABLE variable = p_info->p_compiler->get_variable_address();
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "" );
		p_info->assembler_list.body.push_back( asm_line );
		for( ; p_info->assembler_list.body.size() > lines; ) {
			//	最後の要素を抽出
			asm_line = p_info->assembler_list.body.back();
			p_info->assembler_list.body.pop_back();
			//	バッファの先頭に挿入
			assembler_list_buffer.insert( assembler_list_buffer.begin(), asm_line );
		}
		switch( variable.type ) {
		case CVARIABLE_TYPE::INTEGER:		var_type = 2;	break;
		case CVARIABLE_TYPE::STRING:		var_type = 3;	break;
		case CVARIABLE_TYPE::SINGLE_REAL:	var_type = 4;	break;
		case CVARIABLE_TYPE::DOUBLE_REAL:	var_type = 8;	break;
		default:							var_type = 2;	break;
		}
		if( variable_count == 0 ) {
			s_data = s_data + std::to_string( var_type );
		}
		else {
			s_data = s_data + ", " + std::to_string( var_type );
		}
		variable_count++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
			break;
		}
		p_info->list.p_position++;
	}
	if( variable_count == 0 ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( variable_count > 8 ) {
		p_info->errors.add( OVERFLOW_ERROR, line_no );
		return true;
	}
	p_info->assembler_list.body.insert( p_info->assembler_list.body.end(), assembler_list_buffer.begin(), assembler_list_buffer.end() );

	s_data = s_data + ", 0";

	p_info->assembler_list.activate_sub_input();
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_input", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_data, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->use_input = true;
	return true;
}
