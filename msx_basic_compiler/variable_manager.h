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
#include "error_list.h"
#include "compiler.h"

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
	int				dimention;	//	-1: �v�f���s���̔z��, 0: �ʏ�ϐ�, 1: 1�����z��, 2: 2�����z��, ....

	CVARIABLE(): type( CVARIABLE_TYPE::DOUBLE_REAL ), s_name(""), dimention(0) {
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
	CERROR_LIST *p_errors;

	//	�ϐ��ǉ�����
	void add_variable( CCOMPILER *p_this, bool is_dim = false );

	//	�R�[�h�����߂��ĕϐ����X�g���쐬����
	bool analyze_defvars( std::vector< CBASIC_WORD > list );

	CVARIABLE_MANAGER(): p_errors(nullptr) {
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
