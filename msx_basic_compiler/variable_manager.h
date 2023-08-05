// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <map>
#include "compile_info.h"

#ifndef __VARIABLE_MANAGER_H__
#define __VARIABLE_MANAGER_H__

// --------------------------------------------------------------------
class CVARIABLE_MANAGER {
private:
	//	ステートメントを読み飛ばす
	void skip_statement( CCOMPILE_INFO *p_info );

	//	DEFxxx の情報を更新する
	void update( CCOMPILE_INFO *p_info, CVARIABLE_TYPE new_type );

	//	配列の要素 ( a, b, c ... ) を評価して、要素数を返す
	int evaluate_dimensions( void );
public:
	//	変数追加処理
	CVARIABLE add_variable( CCOMPILE_INFO *p_info, bool is_dim = false );

	//	コードを解釈して変数リストを作成する
	bool analyze_defvars( CCOMPILE_INFO *p_info );
};

#endif
