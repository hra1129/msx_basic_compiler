// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include "variable_manager.h"

// --------------------------------------------------------------------
std::vector< CBASIC_WORD >::const_iterator CVARIABLE_MANAGER::skip_statement( std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end ) {
	int line_no = p_list->line_no;

	while( p_list != p_end ) {
		if( p_list->line_no != line_no ) {
			break;
		}
		if( p_list->s_word == ":" || p_list->s_word == "THEN" || p_list->s_word == "ELSE" ) {
			p_list++;
			break;
		}
		p_list++;
	}
	return p_list;
}

// --------------------------------------------------------------------
std::vector< CBASIC_WORD >::const_iterator CVARIABLE_MANAGER::update( CVARIABLE_TYPE new_type, std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end ) {
	char start_char, end_char;
	std::string s_def = p_list->s_word;
	int line_no = p_list->line_no;
	int i;

	p_list++;
	while( p_list != p_end ) {
		if( p_list->s_word.size() != 1 ) {
			//	DEFINT AA のような、2文字以上の指定だった場合はエラー
			this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
			return this->skip_statement( p_list, p_end );
		}
		if( !isalpha( p_list->s_word[0] & 255 ) ) {
			//	DEFINT 1 のような、アルファベット以外の指定の場合はエラー
			this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
			return this->skip_statement( p_list, p_end );
		}
		start_char = toupper( p_list->s_word[0] & 255 );
		p_list++;
		if( p_list == p_end || p_list->s_word == "," || p_list->s_word == ":" ) {
			//	DEFINT A のような単独指定の場合
			end_char = start_char;
		}
		else if( p_list->s_word == "-" ) {
			//	DEFINT A-Z のような範囲指定の場青
			p_list++;
			if( p_list == p_end || p_list->s_word.size() != 1 || !isalpha( p_list->s_word[0] & 255 ) ) {
				//	DEFINT A- や DEFINT A-AA や DEFINT A-9 のような不正な記述の場合はエラー
				this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
				return this->skip_statement( p_list, p_end );
			}
			end_char = toupper( p_list->s_word[0] & 255 );
			p_list++;
		}
		//	範囲をチェック
		if( start_char > end_char ) {
			//	DEFINT Z-A のような逆巡指定の場合はエラー
			this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
			return p_list;
		}
		//	範囲を登録
		for( i = start_char; i <= end_char; i++ ) {
			this->def_types[ i - 'A' ] = new_type;
		}
		//	次の範囲指定の , は読み飛ばす
		if( p_list != p_end && p_list->s_word == "," ) {
			p_list++;
		}
		else if( p_list != p_end && p_list->s_word == ":" ) {
			p_list++;
			break;
		}
	}
	return p_list;
}

// --------------------------------------------------------------------
//	DEFINT, DEFSNG, DEFDBL, DEFSTR を調べて型識別子無しの変数が
//	どの型になるかを確定させる
bool CVARIABLE_MANAGER::analyze_defvars( std::vector< CBASIC_WORD > list ) {
	std::vector< CBASIC_WORD >::const_iterator p_list;

	p_list = list.begin();
	while( p_list != list.end() ) {
		if( p_list->s_word == "DEFINT" ) {
			p_list = this->update( CVARIABLE_TYPE::INTEGER, p_list, list.end() );
		}
		else if( p_list->s_word == "DEFSNG" ) {
			p_list = this->update( CVARIABLE_TYPE::SINGLE_REAL, p_list, list.end() );
		}
		else if( p_list->s_word == "DEFDBL" ) {
			p_list = this->update( CVARIABLE_TYPE::DOUBLE_REAL, p_list, list.end() );
		}
		else if( p_list->s_word == "DEFSTR" ) {
			p_list = this->update( CVARIABLE_TYPE::STRING, p_list, list.end() );
		}
		else {
			p_list = this->skip_statement( p_list, list.end() );
		}
	}
	return true;
}

// --------------------------------------------------------------------
//	{変数名}[%|!|#|$][(...)]
void CVARIABLE_MANAGER::add_variable( CCOMPILER *p_this, bool is_dim ) {
	CVARIABLE variable;
	std::string s_name;
	int line_no;

	line_no = p_this->p_position->line_no;
	//	変数名を取得する
	s_name = p_this->p_position->s_word;
	p_this->p_position++;
	//	3文字以上の場合、2文字に切り詰める
	if( s_name.size() > 2 ) {
		s_name = std::string( "" ) + s_name[0] + s_name[1];
	}
	//	型識別子の存在を調べる
	if( !p_this->is_end() && p_this->p_position->s_word == "%" ) {
		variable.type = CVARIABLE_TYPE::INTEGER;
		s_name = s_name + "%";
		p_this->p_position++;
	}
	else if( !p_this->is_end() && p_this->p_position->s_word == "!" ) {
		variable.type = CVARIABLE_TYPE::SINGLE_REAL;
		s_name = s_name + "!";
		p_this->p_position++;
	}
	else if( !p_this->is_end() && p_this->p_position->s_word == "#" ) {
		variable.type = CVARIABLE_TYPE::DOUBLE_REAL;
		s_name = s_name + "#";
		p_this->p_position++;
	}
	else if( !p_this->is_end() && p_this->p_position->s_word == "$" ) {
		variable.type = CVARIABLE_TYPE::STRING;
		s_name = s_name + "$";
		p_this->p_position++;
	}
	else {
		//	型識別子が省略されている場合は、DEFxxx の指定に従う
		variable.type = this->def_types[ s_name[0] ];
		switch( variable.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:		s_name = s_name + "%"; break;
		case CVARIABLE_TYPE::SINGLE_REAL:	s_name = s_name + "!"; break;
		case CVARIABLE_TYPE::DOUBLE_REAL:	s_name = s_name + "#"; break;
		case CVARIABLE_TYPE::STRING:		s_name = s_name + "$"; break;
		}
	}
	if( p_this->is_end() ) {
		p_this->p_errors->add( "Syntax error.", line_no );
		return;
	}
	//	配列か？
	if( p_this->p_position->s_word == "(" ) {
		s_name = s_name + "(";
		variable.dimention = -1;		//	今始めて見つけたので、配列なのか、配列なら要素数はいくつか、はまだ分からない。
	}
	variable.s_name = s_name;
	//	既に認知している変数か？
	if( dictionary.count( s_name ) ) {
		variable = dictionary[ s_name ];
	}
}
