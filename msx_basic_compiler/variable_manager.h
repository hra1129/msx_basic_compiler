#pragma once
// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <map>

enum class CVARIABLE_TYPE {
	INTEGER,
	SINGLE_REAL,
	DOUBLE_REAL,
	STRING,
};

struct CVARIABLE {
	CVARIABLE_TYPE	type;
	std::string		s_name;

	CVARIABLE(): type( CVARIABLE_TYPE::DOUBLE_REAL ), s_name("") {
	}
};

class CVARIABLE_MANAGER {
private:
	//	DEFxxx の情報
	std::vector< CVARIABLE_TYPE > def_types;

	//	使用されている変数のリスト
	std::map< std::string, CVARIABLE& > dictionary;
};
