#pragma once
// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <map>
#include "basic_code_loader.h"

enum class CVARIABLE_TYPE {
	INTEGER,
	SINGLE_REAL,
	DOUBLE_REAL,
	STRING,
};

class CVARIABLE {
public:
	CVARIABLE_TYPE	type;
	std::string		s_name;

	CVARIABLE(): type( CVARIABLE_TYPE::DOUBLE_REAL ), s_name("") {
	}
};

class CVARIABLE_MANAGER {
private:
	//	DEFxxx �̏��
	std::vector< CVARIABLE_TYPE > def_types;

	//	�g�p����Ă���ϐ��̃��X�g
	std::map< std::string, CVARIABLE > dictionary;

	//	�X�e�[�g�����g��ǂݔ�΂�
	std::vector< CBASIC_WORD >::const_iterator skip_statement( std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end );

	//	DEFxxx �̏����X�V����
	std::vector< CBASIC_WORD >::const_iterator update( CVARIABLE_TYPE new_type, std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end );
public:
	//	�R�[�h�����߂��ĕϐ����X�g���쐬����
	bool analyze_defvars( std::vector< CBASIC_WORD > list );

	CVARIABLE_MANAGER() {
		this->def_types.resize( 26 );
		for( auto &p: def_types ) {
			p = CVARIABLE_TYPE::DOUBLE_REAL;
		}
	}

	//	�e�X�g�p I/F
	std::vector< CVARIABLE_TYPE > get_def_types( void ) {
		return def_types;
	}
};
