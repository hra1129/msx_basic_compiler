// --------------------------------------------------------------------
//	Compiler collection: Data
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "data.h"

// --------------------------------------------------------------------
//  DATA データ
bool CDATA::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	CSTRING value;
	std::string s_label;

	if( p_info->list.p_position->s_word != "DATA" ) {
		return false;
	}
	p_info->list.p_position++;

	//	RESTORE用の行番号ラベルを割り付ける
	bool has_data_label = false;
	for( auto i: p_info->assembler_list.data_lines ) {
		if( line_no == i ) {
			has_data_label = true;
			break;
		}
	}
	if( !has_data_label ) {
		s_label = "data_" + std::to_string( line_no );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.datas.push_back( asm_line );
		p_info->assembler_list.data_lines.push_back( line_no );
	}

	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::STRING ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		value.set( p_info->list.p_position->s_word );
		s_label = p_info->constants.add( value );
		asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.datas.push_back( asm_line );
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD && p_info->list.p_position->s_word != "," ) {
			break;
		}
		p_info->list.p_position++;
	}
	return true;
}
