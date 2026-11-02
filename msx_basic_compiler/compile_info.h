// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <map>
#include <set>
#include "basic_types.h"
#include "basic_list.h"
#include "error_list.h"
#include "variable_info.h"
#include "constant_info.h"
#include "assembler/assembler_list.h"
#include "variable_manager.h"

#ifndef __COMPILE_INFO_H__
#define __COMPILE_INFO_H__

class CCOMPILE_INFO {
private:
	// ----------------------------------------------------------------
	//	自動生成ラベルのインデックス
	// ----------------------------------------------------------------
	int					auto_label_index;

public:
	CCOMPILE_INFO(): auto_label_index(0) {
	}

	class CCOMPILER		*p_compiler = nullptr;

	// ----------------------------------------------------------------
	//	BASICのソースコードとその参照位置を保持
	// ----------------------------------------------------------------
	CBASIC_LIST			list;

	// ----------------------------------------------------------------
	//	変数を保持
	// ----------------------------------------------------------------
	CVARIABLE_INFO		variables;

	// ----------------------------------------------------------------
	//	定数を保持
	// ----------------------------------------------------------------
	CCONSTANT_INFO		constants;

	// ----------------------------------------------------------------
	//	発見した全てのエラーを保持
	// ----------------------------------------------------------------
	CERROR_LIST			errors;

	// ----------------------------------------------------------------
	//	コンパイル結果を保持
	// ----------------------------------------------------------------
	CASSEMBLER_LIST		assembler_list;

	// ----------------------------------------------------------------
	//	コンパイルオプションを保持
	// ----------------------------------------------------------------
	COPTIONS			options;

	// ----------------------------------------------------------------
	//	変数の管理
	// ----------------------------------------------------------------
	CVARIABLE_MANAGER	variable_manager;

	// ----------------------------------------------------------------
	//	ラベルの自動生成
	// ----------------------------------------------------------------
	std::string get_auto_label( void ) {
		std::string s;
		s = "_pt" + std::to_string( this->auto_label_index );
		this->auto_label_index++;
		return s;
	}

	// ----------------------------------------------------------------
	//	FOR文のループ変数スタック
	// ----------------------------------------------------------------
	std::vector< CVARIABLE > for_variable_array;

	// ----------------------------------------------------------------
	//	DEF FN の定義情報 (事前スキャンで登録し、呼び出し側で本体を
	//	インライン展開する。再帰呼び出しは展開中の名前で禁止する)
	// ----------------------------------------------------------------
	class CFN_DEFINITION {
	public:
		CVARIABLE param;										//	引数変数
		CEXPRESSION_TYPE result_type = CEXPRESSION_TYPE::DOUBLE_REAL;
		int def_line_no = 0;									//	定義した行番号 (定義前使用の検出用)
		std::vector< CBASIC_WORD >::const_iterator p_body;		//	本体式の先頭位置
	};
	std::map< std::string, CFN_DEFINITION > fn_definitions;
	std::vector< std::string > fn_expanding;
	int fn_root_line = 0;		//	展開の起点となった呼び出し行 (定義前使用の判定用)

	// ----------------------------------------------------------------
	//	OPEN/CLOSE/MAXFILES文の使用フラグ
	// ----------------------------------------------------------------
	bool use_file_access = false;

	// ----------------------------------------------------------------
	//	割り込み処理の利用フラグ
	// ----------------------------------------------------------------
	bool use_on_interval = false;
	bool use_on_strig = false;
	bool use_on_sprite = false;
	bool use_on_key = false;
	bool use_on_stop = false;
	bool use_return_line_no = false;
	bool use_input = false;
	bool use_on_error = false;

	// ----------------------------------------------------------------
	//	ON ERROR 用の文マーカー一覧 (出現順: ラベル, 行番号)
	// ----------------------------------------------------------------
	std::vector< std::pair< std::string, int > > error_mark_list;

	// ----------------------------------------------------------------
	//	[B6] FOR/NEXT 静的ペアリング用 (O3 のみ)
	// ----------------------------------------------------------------
	class CFOR_B6_RECORD {
	public:
		std::string s_var_label;		//	ループ変数のラベル
		std::string s_cell_label;		//	_LABEL セルのラベル
		std::string s_next_label;		//	NEXT ブロックのラベル
		size_t store_body_index = 0;	//	FOR 側セル保存コードの body 位置
		int for_line_no = 0;
		int next_line_no = 0;
		bool paired = false;
	};
	std::vector< CFOR_B6_RECORD > for_b6_records;
	std::vector< int > for_b6_stack;					//	for_variable_array と並行
	std::set< std::string > b6_cell_used_vars;			//	セル経由で参照された _LABEL セル
	std::vector< int > label_target_lines;				//	飛び先になっているラベルの定義行

	bool is_interrupt_use( void ) const {
		return( this->use_on_interval || this->use_on_strig || this->use_on_sprite || this->use_on_stop || this->use_on_key );
	}
};

// --------------------------------------------------------------------
class CCOMPILER_CONTAINER {
public:
	virtual ~CCOMPILER_CONTAINER() = default;
	// ----------------------------------------------------------------
	//	このコンテナが対応する記述だけをコンパイルする
	//	このコンテナが対応する記述だった場合は、true を返す
	virtual bool exec( CCOMPILE_INFO *p_info ) = 0;
};

#endif
