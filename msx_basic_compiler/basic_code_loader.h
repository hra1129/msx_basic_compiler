#pragma once
// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <cstdio>

// --------------------------------------------------------------------
//	BASIC‚Ì’PŒê‚ðŽ¦‚·
class CBASIC_WORD {
public:
	int line_no;
	std::string s_word;
};

// --------------------------------------------------------------------
//	BASIC‚Ì’PŒê”z—ñ
class CBASIC_LIST {
private:
	std::vector< CBASIC_WORD > words;
	std::string s_error_message;

	bool check_binary_program( FILE *p_file );
	bool load_binary( FILE *p_file );
	bool load_ascii( FILE *p_file );
public:
	CBASIC_LIST(): s_error_message("") {
	}

	bool load( const std::string &s_file_name );
};
