// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <cstdio>
#include "basic_types.h"
#include "error_list.h"

#ifndef __BASIC_LIST_H__
#define __BASIC_LIST_H__

// --------------------------------------------------------------------
//	BASICの単語を示す
class CBASIC_WORD {
public:
	int line_no;
	CBASIC_WORD_TYPE type;
	std::string s_word;

	CBASIC_WORD(): line_no(0), type(CBASIC_WORD_TYPE::UNKNOWN) {
	}
};

// --------------------------------------------------------------------
//	BASICの単語配列
class CBASIC_LIST {
private:
	std::vector< unsigned char > file_image;
	std::vector< unsigned char >::const_iterator p_file_image;

	std::vector< CBASIC_WORD > words;
	int line_no;
	int current_line_no;

	bool check_binary_program( FILE *p_file );
	bool load_file( FILE *p_file );
	void skip_white_space( void );
	int get_integer( void );
	int get_1byte( void );
	int get_2bytes( void );
	std::string get_word_in_charlist( const char *p_charlist, bool ignore_space = false );
	std::string get_char_in_charlist( const char *p_charlist, bool ignore_space = false );
	CBASIC_WORD get_decimal( const std::string s, const std::string s_type );
	CBASIC_WORD get_comment( void );
	CBASIC_WORD get_word( void );
	CBASIC_WORD get_ascii_word( void );
	CBASIC_WORD get_data_word( void );

	bool load_binary( FILE *p_file, CERROR_LIST &errors );
	bool load_ascii( FILE *p_file, CERROR_LIST &errors );

public:
	std::string s_source_type;
	std::vector< CBASIC_WORD >::const_iterator p_position;
	std::vector< int > jump_target_line_no;
	std::vector< int > data_line_no;

	CBASIC_LIST(): line_no(0), current_line_no(0) {
	}

	void reset_position( void ) {
		this->p_position = words.begin();
		this->current_line_no = -1;
	}

	bool is_end( void );
	bool is_line_end( void );
	bool is_command_end( void );
	bool load( const std::string &s_file_name, CERROR_LIST &errors );

	void update_current_line_no( void ) {
		if( this->is_end() ) {
			this->current_line_no = -1;
			return;
		}
		this->current_line_no = this->p_position->line_no; 
	}

	int get_line_no( void ) const {
		return this->current_line_no;
	}

	std::vector< CBASIC_WORD > get_word_list( void ) {
		return words;
	}

	void skip_statement( void );

	// ----------------------------------------------------------------
	//	次が指定の単語で無ければ指定のエラーにする
	bool check_word( CERROR_LIST *p_error, std::string s, CERROR_ID error_id = SYNTAX_ERROR );
};

#endif
