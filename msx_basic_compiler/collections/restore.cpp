// --------------------------------------------------------------------
//	Compiler collection: Restore
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "restore.h"

// --------------------------------------------------------------------
//  RESTORE [行番号]
bool CRESTORE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	int target_line_no, last_line_no;
	std::string s_label;
	bool target_is_found;

	if( p_info->list.p_position->s_word != "RESTORE" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		//	行番号が省略されている場合
		if( p_info->list.data_line_no.size() != 0 ) {
			//	データがある場合にのみコードを生成する
			s_label = "data_" + std::to_string( p_info->list.data_line_no[0] );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[data_ptr]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		return true;
	}
	if( p_info->list.p_position->type != CBASIC_WORD_TYPE::LINE_NO ) {
		//	行番号で無い何かが指定されている場合
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	//	行番号が指定されている場合
	target_line_no = std::stoi( p_info->list.p_position->s_word );
	target_is_found = false;
	last_line_no = -1;
	for( auto i: p_info->list.data_line_no ) {
		if( target_line_no > i ) {
			target_line_no = last_line_no;
			target_is_found = true;
			break;
		}
		if( target_line_no == i ) {
			target_line_no = i;
			target_is_found = true;
			break;
		}
		last_line_no = i;
	}
	if( !target_is_found ) {
		//	行番号の指定が最後のデータの行より大きい値
		p_info->errors.add( UNDIFINED_LINE_NUMBER, line_no );
		return true;
	}
	s_label = "data_" + std::to_string( target_line_no );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[data_ptr]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
