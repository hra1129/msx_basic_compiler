// --------------------------------------------------------------------
//	Variable information
// ====================================================================
//	2023/Aug/5th  t.hara
// --------------------------------------------------------------------

#include <string>
#include <vector>
#include <map>
#include "assembler/assembler_list.h"

#ifndef __VARIABLE_INFO_H__
#define __VARIABLE_INFO_H__

// --------------------------------------------------------------------
enum class CVARIABLE_TYPE {
	UNSIGNED_BYTE,
	INTEGER,
	SINGLE_REAL,
	DOUBLE_REAL,
	STRING,
	UNKNOWN,
};

// --------------------------------------------------------------------
class CVARIABLE {
public:
	CVARIABLE_TYPE	type;
	std::string		s_name;		//	�ϐ��̖��O
	std::string		s_label;	//	�ϐ��̈�̃��x���� ( dictionary �̃C���f�b�N�X )
	int				dimension;	//	-1: �v�f���s���̔z��, 0: �ʏ�ϐ�, 1: 1�����z��, 2: 2�����z��, ....

	CVARIABLE(): type( CVARIABLE_TYPE::DOUBLE_REAL ), s_name(""), dimension(0) {
	}
};

// --------------------------------------------------------------------
class CVARIABLE_INFO {
public:

	//	DEFxxx �̏��
	std::vector< CVARIABLE_TYPE > def_types;

	//	�g�p����Ă���ϐ��̃��X�g
	std::map< std::string, CVARIABLE > dictionary;

	//	�R���X�g���N�^
	CVARIABLE_INFO() {
		this->def_types.resize( 26 );
		for( auto &p: def_types ) {
			p = CVARIABLE_TYPE::DOUBLE_REAL;
		}
	}

	int var_area_size = 0;
	int vars_area_count = 0;
	int vara_area_count = 0;

	void dump( CASSEMBLER_LIST &asm_list, COPTIONS options ) {
		std::string s;
		CASSEMBLER_LINE asm_line;

		var_area_size = 0;
		vars_area_count = 0;
		vara_area_count = 0;
		//	�z��łȂ������E�P���x�E�{���x�ϐ�
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "var_area_start", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );
		for( auto it = dictionary.begin(); it != dictionary.end(); it++ ) {
			if( it->second.dimension != 0 || it->second.type == CVARIABLE_TYPE::STRING ) {
				continue;
			}
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, it->first, COPERAND_TYPE::NONE, "" );
			asm_list.variables_area.push_back( asm_line );
			switch( it->second.type ) {
			case CVARIABLE_TYPE::UNSIGNED_BYTE:
				asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
				asm_list.variables_area.push_back( asm_line );
				var_area_size += 1;
				break;
			case CVARIABLE_TYPE::INTEGER:
				asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
				asm_list.variables_area.push_back( asm_line );
				var_area_size += 2;
				break;
			case CVARIABLE_TYPE::SINGLE_REAL:
				asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0, 0", COPERAND_TYPE::NONE, "" );
				asm_list.variables_area.push_back( asm_line );
				var_area_size += 4;
				break;
			case CVARIABLE_TYPE::DOUBLE_REAL:
				asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0, 0, 0, 0", COPERAND_TYPE::NONE, "" );
				asm_list.variables_area.push_back( asm_line );
				var_area_size += 8;
				break;
			default:
				break;
			}
		}
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "var_area_end", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );

		//	�z��łȂ�������
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "vars_area_start", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );
		for( auto it = dictionary.begin(); it != dictionary.end(); it++ ) {
			if( it->second.dimension != 0 || it->second.type != CVARIABLE_TYPE::STRING ) {
				continue;
			}
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, it->first, COPERAND_TYPE::NONE, "" );
			asm_list.variables_area.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );		//	�A�h���X
			asm_list.variables_area.push_back( asm_line );
			vars_area_count++;
		}
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "vars_area_end", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );

		//	�z��̐����E�P���x�E�{���x�ϐ�
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "vara_area_start", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );
		for( auto it = dictionary.begin(); it != dictionary.end(); it++ ) {
			if( it->second.dimension == 0 || it->second.type == CVARIABLE_TYPE::STRING ) {
				continue;
			}
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, it->first, COPERAND_TYPE::NONE, "" );
			asm_list.variables_area.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );		//	�A�h���X
			asm_list.variables_area.push_back( asm_line );
			vara_area_count++;
		}
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "vara_area_end", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );

		//	�z��̕�����
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "varsa_area_start", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );
		for( auto it = dictionary.begin(); it != dictionary.end(); it++ ) {
			if( it->second.dimension == 0 || it->second.type != CVARIABLE_TYPE::STRING ) {
				continue;
			}
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, it->first, COPERAND_TYPE::NONE, "" );
			asm_list.variables_area.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );		//	�A�h���X
			asm_list.variables_area.push_back( asm_line );
			vara_area_count++;
		}
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "varsa_area_end", COPERAND_TYPE::NONE, "" );
		asm_list.variables_area.push_back( asm_line );
	}
};

#endif
