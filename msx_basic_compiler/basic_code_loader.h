#pragma once
// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <cstdio>

enum class CBASIC_WORD_TYPE {
	UNKNOWN,				//	0:���m
	UNKNOWN_NAME,		//	1:�����̖��O
	SYMBOL,				//	2:�L��
	INTEGER,			//	3:����
	SINGLE_REAL,		//	4:�P���x����
	DOUBLE_REAL,		//	5:�{���x����
	STRING,				//	6:������
	RESERVED_WORD,		//	7:�\���
	LINE_NO,			//	8:�s�ԍ�
};

// --------------------------------------------------------------------
//	BASIC�̒P�������
class CBASIC_WORD {
public:
	int line_no;
	CBASIC_WORD_TYPE type;
	std::string s_word;
};

// --------------------------------------------------------------------
//	BASIC�̒P��z��
class CBASIC_LIST {
private:
	std::vector< unsigned char > file_image;
	std::vector< unsigned char >::const_iterator p_file_image;

	std::vector< CBASIC_WORD > words;
	std::string s_error_message;
	int line_no;

	bool check_binary_program( FILE *p_file );
	bool load_file( FILE *p_file );
	void skip_white_space( void );
	int get_integer( void );
	int get_1byte( void );
	int get_2bytes( void );
	std::string get_word_in_charlist( const char *p_charlist );
	CBASIC_WORD get_word( void );
	CBASIC_WORD get_ascii_word( void );
	bool load_binary( FILE *p_file );
	bool load_ascii( FILE *p_file );
public:
	CBASIC_LIST(): s_error_message(""), line_no(0) {
	}

	bool load( const std::string &s_file_name );

	std::vector< CBASIC_WORD > get_word_list( void ) {
		return words;
	}
};
