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
	//	DEFxxx の情報
	std::vector< CVARIABLE_TYPE > def_types;

	//	使用されている変数のリスト
	std::map< std::string, CVARIABLE > dictionary;

	//	ステートメントを読み飛ばす
	std::vector< CBASIC_WORD >::const_iterator skip_statement( std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end );

	//	DEFxxx の情報を更新する
	std::vector< CBASIC_WORD >::const_iterator update( CVARIABLE_TYPE new_type, std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end );
public:
	//	コードを解釈して変数リストを作成する
	bool analyze_defvars( std::vector< CBASIC_WORD > list );

	CVARIABLE_MANAGER() {
		this->def_types.resize( 26 );
		for( auto &p: def_types ) {
			p = CVARIABLE_TYPE::DOUBLE_REAL;
		}
	}

	//	テスト用 I/F
	std::vector< CVARIABLE_TYPE > get_def_types( void ) {
		return def_types;
	}
};
