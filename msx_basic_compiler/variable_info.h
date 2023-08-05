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
	int				dimension;	//	-1: 要素数不明の配列, 0: 通常変数, 1: 1次元配列, 2: 2次元配列, ....

	CVARIABLE(): type( CVARIABLE_TYPE::DOUBLE_REAL ), s_name(""), dimension(0) {
	}
};

// --------------------------------------------------------------------
class CVARIABLE_INFO {
public:

	//	DEFxxx の情報
	std::vector< CVARIABLE_TYPE > def_types;

	//	使用されている変数のリスト
	std::map< std::string, CVARIABLE > dictionary;

	//	コンストラクタ
	CVARIABLE_INFO() {
		this->def_types.resize( 26 );
		for( auto &p: def_types ) {
			p = CVARIABLE_TYPE::DOUBLE_REAL;
		}
	}
};

#endif
