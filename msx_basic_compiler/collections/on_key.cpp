// --------------------------------------------------------------------
//	Compiler collection: On Key
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "on_key.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//	KEY {ON|OFF|STOP}
void CONKEY::key( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	CEXPRESSION exp;

	p_info->list.p_position++;

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ) {
		return;
	}
	p_info->list.p_position++;

	if( exp.compile( p_info ) ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::AND, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "15" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::CONSTANT, "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "svarf_on_key01_mode - 4" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
		p_info->use_on_key = true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return;
	}

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return;
	}
	p_info->list.p_position++;

	if( p_info->list.p_position->s_word == "OFF" || p_info->list.p_position->s_word == "STOP" ) {
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		p_info->use_on_key = true;
	}
	else if( p_info->list.p_position->s_word == "ON" ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[HL]", COPERAND_TYPE::CONSTANT, "0xFF" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		p_info->use_on_key = true;
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
	}
}

// --------------------------------------------------------------------
//  ON KEY GOSUB <飛び先0>, <飛び先1>, ... , <飛び先3>, <飛び先9>
bool CONKEY::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	int i;

	if( p_info->list.p_position->s_word == "KEY" ) {
		//	KEY(n) {ON|OFF|STOP}
		this->key( p_info );
		return true;
	}
	if( p_info->list.p_position->s_word != "ON" ) {
		return false;
	}
	//	ON KEY GOSUB line
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word != "KEY" ) {
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
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	for( i = 0; i < 10; i++ ) {
		//	行番号の記述がない場合はエラー
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
			if( p_info->list.p_position->s_word[0] == '*' ) {
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "label_" + p_info->list.p_position->s_word.substr(1) );
			}
			else {
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "line_" + p_info->list.p_position->s_word );
			}
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, ((i<9)?"[svari_on_key0":"[svari_on_key") + std::to_string(i+1) + "_line]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->list.p_position++;
		}
		if( p_info->list.is_command_end() ) {
			//	行番号のすぐ次でコマンドが終わっていれば終わる
			break;
		}
		if( p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}
	asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->use_on_key = true;
	return true;
}
