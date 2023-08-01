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

	//	配列の要素 ( a, b, c ... ) を評価して、要素数を返す
	int evaluate_dimensions( void );
public:
	CERROR_LIST *p_errors;

	//	変数追加処理
	CVARIABLE add_variable( class CCOMPILER *p_this, bool is_dim = false );

	//	コードを解釈して変数リストを作成する
	bool analyze_defvars( std::vector< CBASIC_WORD > list );

	CVARIABLE_MANAGER(): p_errors(nullptr) {
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
