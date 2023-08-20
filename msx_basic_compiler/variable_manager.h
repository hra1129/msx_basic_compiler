// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <map>
#include "variable_info.h"

#ifndef __VARIABLE_MANAGER_H__
#define __VARIABLE_MANAGER_H__

// --------------------------------------------------------------------
class CVARIABLE_MANAGER {
private:
	//	ステートメントを読み飛ばす
	void skip_statement( class CCOMPILE_INFO *p_info );

	//	DEFxxx の情報を更新する
	void update( class CCOMPILE_INFO *p_info, CVARIABLE_TYPE new_type );

	//	配列の要素 ( a, b, c ... ) を評価して、要素数を返す
	int evaluate_dimensions( void );
public:
	//	変数追加処理
	CVARIABLE add_variable( class CCOMPILE_INFO *p_info, bool is_dim = false );

	//	コードを解釈して変数リストを作成する
	bool analyze_defvars( class CCOMPILE_INFO *p_info );

	//	現在の参照位置の変数の情報を返す
	CVARIABLE get_variable_info( class CCOMPILE_INFO *p_info );
};

#endif
