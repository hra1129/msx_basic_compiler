// --------------------------------------------------------------------
//	Compiler collection: On Goto/Gosub
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "on_goto.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  ON <式> {GOTO|GOSUB} <飛び先0>, <飛び先1>, ...
bool CONGOTO::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	bool is_gosub = false;
	std::vector< CBASIC_WORD >::const_iterator p_position;
	std::vector< std::string > line_no_list;

	p_position = p_info->list.p_position;
	if( p_info->list.p_position->s_word != "ON" ) {
		return false;
	}
	p_info->list.p_position++;
	//	<式> が存在しない場合はエラー
	if( p_info->list.is_command_end() ) {
		p_info->list.p_position = p_position;
		return false;
	}
	//	<式> を解釈する (※この時点で、まだ ON <式> {GOTO|GOSUB} かは未確定
	exp.makeup_node( p_info );
	//	ON <式> {GOTO|GOSUB} 判断
	if( p_info->list.is_command_end() ) {
		p_info->list.p_position = p_position;
		return false;
	}
	if( p_info->list.p_position->s_word == "GOTO" ) {
		is_gosub = false;
	}
	else if( p_info->list.p_position->s_word == "GOSUB" ) {
		is_gosub = true;
	}
	else {
		p_info->list.p_position = p_position;
		return false;
	}
	p_info->list.p_position++;

	//	行番号がいくつあるか集計する
	for( ;; ) {
		if( p_info->list.is_command_end() ) {
			//	行番号があるべきところに何もない場合（飛び先が一つもない場合も含む）
			p_info->errors.add( SYNTAX_ERROR, line_no );
			break;
		}
		if( p_info->list.p_position->s_word == "," ) {
			//	行番号が省略されている場合
			line_no_list.push_back( "#" );		//	# は省略を示すマジックナンバー
			p_info->list.p_position++;
			continue;
		}
		if( p_info->list.p_position->type == CBASIC_WORD_TYPE::LINE_NO ) {
			//	行番号があった場合
			line_no_list.push_back( p_info->list.p_position->s_word );
			p_info->list.p_position++;
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			break;
		}
		if( p_info->list.is_command_end() ) {
			//	終わった場合
			break;
		}
		if( p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			break;
		}
		p_info->list.p_position++;
	}

	//	<式> をコンパイルする
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	//	評価結果でジャンプ
	std::string s_through_label, s_table_label;
	s_through_label = p_info->get_auto_label();
	s_table_label = p_info->get_auto_label();

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::Z, COPERAND_TYPE::CONSTANT, s_through_label, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, std::to_string( (int)line_no_list.size() + 1 ) );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NC, COPERAND_TYPE::CONSTANT, s_through_label, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, s_table_label + " - 2" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY, "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY, "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	if( is_gosub ) {
		//	GOSUB の場合
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, s_through_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	GOTO の場合
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	行番号テーブル
	p_info->assembler_list.add_label( "bios_syntax_error", "0x04055" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_table_label, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	for( size_t i = 0; i < line_no_list.size(); i++ ) {
		if( line_no_list[i] != "#" ) {
			if( line_no_list[i][0] == '*' ) {
				asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "label_" + line_no_list[i].substr(1), COPERAND_TYPE::NONE, "" );
			}
			else {
				asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "line_" + line_no_list[i], COPERAND_TYPE::NONE, "" );
			}
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_syntax_error", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_through_label, COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
