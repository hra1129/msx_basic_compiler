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
	int evaluate_dimensions( class CCOMPILE_INFO *p_info );
public:
	//	変数追加処理
	CVARIABLE add_variable( class CCOMPILE_INFO *p_info );

	//	コードを解釈して変数リストを作成する
	bool analyze_defvars( class CCOMPILE_INFO *p_info );

	//	現在の参照位置の変数を生成して情報を返す
	CVARIABLE create_variable_info( class CCOMPILE_INFO *p_info, bool with_array = true );

	//	現在の参照位置の変数の情報を返す
	CVARIABLE get_variable_info( class CCOMPILE_INFO *p_info, std::vector< class CEXPRESSION* > &exp_list, bool with_array = true );

	//	現在の参照位置の配列変数(要素ではなく配列全体)の情報を返す
	CVARIABLE get_array_info( class CCOMPILE_INFO *p_info );

	//	配列要素の式の配列 exp_list をコンパイルするコードを生成する。HL に変数のアドレスが入っている前提である。
	void compile_array_elements( class CCOMPILE_INFO *p_info, std::vector< class CEXPRESSION* > &exp_list, CVARIABLE &variable );

	//	特殊変数を定義する
	CVARIABLE put_special_variable( class CCOMPILE_INFO *p_info, const std::string s_name, CVARIABLE_TYPE var_type, CVARIABLE_TYPE var_name_type = CVARIABLE_TYPE::UNKNOWN );
};

#endif
