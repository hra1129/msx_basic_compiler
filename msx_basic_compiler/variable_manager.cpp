// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include "variable_manager.h"
#include "compile_info.h"

// --------------------------------------------------------------------
void CVARIABLE_MANAGER::skip_statement( CCOMPILE_INFO *p_info ) {

	p_info->list.update_current_line_no();
	while( !p_info->list.is_line_end() ) {
		if( p_info->list.p_position->s_word == "THEN" || p_info->list.p_position->s_word == "ELSE" || p_info->list.p_position->s_word == ":" ) {
			p_info->list.p_position++;
			break;
		}
		p_info->list.p_position++;
	}
}

// --------------------------------------------------------------------
void CVARIABLE_MANAGER::update( CCOMPILE_INFO *p_info, CVARIABLE_TYPE new_type ) {
	char start_char, end_char;
	std::string s_def = p_info->list.p_position->s_word;
	int i;

	p_info->list.update_current_line_no();
	p_info->list.p_position++;
	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word.size() != 1 ) {
			//	DEFINT AA のような、2文字以上の指定だった場合はエラー
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			this->skip_statement( p_info );
			return;
		}
		if( !isalpha( p_info->list.p_position->s_word[0] & 255 ) ) {
			//	DEFINT 1 のような、アルファベット以外の指定の場合はエラー
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			this->skip_statement( p_info );
			return;
		}
		start_char = toupper( p_info->list.p_position->s_word[0] & 255 );
		end_char = start_char;
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word == "," ) {
			//	DEFINT A のような単独指定の場合
		}
		else if( p_info->list.p_position->s_word == "-" ) {
			//	DEFINT A-Z のような範囲指定の場青
			p_info->list.p_position++;
			if( p_info->list.is_command_end() || p_info->list.p_position->s_word.size() != 1 || !isalpha( p_info->list.p_position->s_word[0] & 255 ) ) {
				//	DEFINT A- や DEFINT A-AA や DEFINT A-9 のような不正な記述の場合はエラー
				p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
				this->skip_statement( p_info );
				return;
			}
			end_char = toupper( p_info->list.p_position->s_word[0] & 255 );
			p_info->list.p_position++;
		}
		//	範囲をチェック
		if( start_char > end_char ) {
			//	DEFINT Z-A のような逆巡指定の場合はエラー
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			return;
		}
		//	範囲を登録
		for( i = start_char; i <= end_char; i++ ) {
			p_info->variables.def_types[ i - 'A' ] = new_type;
		}
		//	次の範囲指定の , は読み飛ばす
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
			p_info->list.p_position++;
		}
	}
}

// --------------------------------------------------------------------
//	DEFINT, DEFSNG, DEFDBL, DEFSTR を調べて型識別子無しの変数が
//	どの型になるかを確定させる
bool CVARIABLE_MANAGER::analyze_defvars( CCOMPILE_INFO *p_info ) {

	while( !p_info->list.is_end() ) {
		if( p_info->list.p_position->s_word == "DEFINT" ) {
			this->update( p_info, CVARIABLE_TYPE::INTEGER );
		}
		else if( p_info->list.p_position->s_word == "DEFSNG" ) {
			this->update( p_info, CVARIABLE_TYPE::SINGLE_REAL );
		}
		else if( p_info->list.p_position->s_word == "DEFDBL" ) {
			this->update( p_info, CVARIABLE_TYPE::DOUBLE_REAL );
		}
		else if( p_info->list.p_position->s_word == "DEFSTR" ) {
			this->update( p_info, CVARIABLE_TYPE::STRING );
		}
		else {
			this->skip_statement( p_info );
		}
	}
	return true;
}

// --------------------------------------------------------------------
//	{変数名}[%|!|#|$][(...)]
CVARIABLE CVARIABLE_MANAGER::add_variable( CCOMPILE_INFO *p_info, bool is_dim ) {
	CVARIABLE variable;
	std::string s_name;
	int line_no;
	int dimensions = 0;

	line_no = p_info->list.p_position->line_no;
	//	変数名を取得する
	s_name = p_info->list.p_position->s_word;
	p_info->list.p_position++;
	//	3文字以上の場合、2文字に切り詰める
	if( s_name.size() > 2 ) {
		s_name = std::string( "" ) + s_name[0] + s_name[1];
	}
	//	型識別子の存在を調べる
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "%" ) {
		variable.type = CVARIABLE_TYPE::INTEGER;
		s_name = s_name + "%";
		p_info->list.p_position++;
	}
	else if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "!" ) {
		variable.type = CVARIABLE_TYPE::SINGLE_REAL;
		s_name = s_name + "!";
		p_info->list.p_position++;
	}
	else if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "#" ) {
		variable.type = CVARIABLE_TYPE::DOUBLE_REAL;
		s_name = s_name + "#";
		p_info->list.p_position++;
	}
	else if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "$" ) {
		variable.type = CVARIABLE_TYPE::STRING;
		s_name = s_name + "$";
		p_info->list.p_position++;
	}
	else {
		//	型識別子が省略されている場合は、DEFxxx の指定に従う
		variable.type = p_info->variables.def_types[ s_name[0] ];
		switch( variable.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:		s_name = s_name + "%"; break;
		case CVARIABLE_TYPE::SINGLE_REAL:	s_name = s_name + "!"; break;
		case CVARIABLE_TYPE::DOUBLE_REAL:	s_name = s_name + "#"; break;
		case CVARIABLE_TYPE::STRING:		s_name = s_name + "$"; break;
		}
	}
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return variable;
	}
	//	配列か？
	if( p_info->list.p_position->s_word == "(" ) {
		s_name = s_name + "(";
		variable.dimension = -1;		//	配列なのは確かだが、要素数はまだ分からない。
		dimensions = this->evaluate_dimensions();		//	要素番号をスタックに積む
	}
	else if( is_dim ) {
		//	DIM A のように、DIM宣言の中で要素数指定が省略されている場合 (10) が指定されたモノとする
		s_name = s_name + "(";
		variable.dimension = 1;			//	1次元配列
		dimensions = 1;
		//	要素番号をスタックに積む
		//	★	p_this->body.push_back( "\t\tld\t\thl, 10" );
		//	★	p_this->body.push_back( "\t\tpush\thl" );
	}

	variable.s_name = s_name;
	if( p_info->variables.dictionary.count( s_name ) ) {
		//	既に認知している変数の場合、配列の次元数をチェック
		variable = p_info->variables.dictionary[ s_name ];
		if( dimensions != variable.dimension ) {
			p_info->errors.add( REDIMENSIONED_ARRAY, line_no );
			return variable;
		}
	}
	else {
		//	初めて登場する変数の場合、辞書に登録して認知
		p_info->variables.dictionary[ s_name ] = variable;
	}

	if( is_dim ) {
		//	配列宣言DIM だった場合、HLに配列ポインタのアドレスを入れて redim を呼ぶ


	}
	return variable;
}

// --------------------------------------------------------------------
//	配列の要素に指定されている式を評価してスタックに積む
int CVARIABLE_MANAGER::evaluate_dimensions( void ) {

	//	★
	return 0;
}

// --------------------------------------------------------------------
CVARIABLE CVARIABLE_MANAGER::get_variable_info( class CCOMPILE_INFO *p_info ) {
	std::string s_name;
	std::string s_label;
	CVARIABLE_TYPE var_type;
	CVARIABLE variable;
	bool is_array = false;

	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		return variable;
	}
	//	変数名を取得
	s_name = p_info->list.p_position->s_word;
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	変数名最大 2文字制限
		s_name.resize( 2 );
	}
	//	型識別子
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "%" ) {
			var_type = CVARIABLE_TYPE::INTEGER;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "!" ) {
			var_type = CVARIABLE_TYPE::SINGLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "#" ) {
			var_type = CVARIABLE_TYPE::DOUBLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "$" ) {
			var_type = CVARIABLE_TYPE::STRING;
			p_info->list.p_position++;
		}
		else {
			var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
		}
	}
	else {
		var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
	}
	//	配列変数か？
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "(" || p_info->list.p_position->s_word == "[" ) {
			//	配列変数の場合
			is_array = true;
			p_info->list.p_position++;
		}
	}
	//	変数ラベルを生成
	switch( var_type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		s_label = "vari";	break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "varf";	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "vard";	break;
	case CVARIABLE_TYPE::STRING:		s_label = "vars";	break;
	}
	if( is_array ) {
		s_label = s_label + "a";
	}
	s_label = s_label + "_" + s_name;
	//	変数を登録する
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( is_array ) {
		//	配列の要素数を調べる
		//	★T.B.D.
	}
	if( p_info->variables.dictionary.count( s_label ) == 0 ) {
		p_info->variables.dictionary[ s_label ] = variable;
	}
	else {
		variable = p_info->variables.dictionary[ s_label ];
	}
	return variable;
}
