// --------------------------------------------------------------------
//	Variable information
// ====================================================================
//	2023/Aug/5th  t.hara
// --------------------------------------------------------------------

#include <string>
#include <vector>
#include <map>

#ifndef __VARIABLE_INFO_H__
#define __VARIABLE_INFO_H__

// --------------------------------------------------------------------
enum class CVARIABLE_TYPE {
	INTEGER,
	SINGLE_REAL,
	DOUBLE_REAL,
	STRING,
};

// --------------------------------------------------------------------
class CVARIABLE {
public:
	CVARIABLE_TYPE	type;
	std::string		s_name;
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
};

#endif
