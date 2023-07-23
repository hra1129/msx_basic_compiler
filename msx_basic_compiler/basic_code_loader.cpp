// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include "basic_code_loader.h"
#include <cstring>

struct CBASIC_RESERVED_WORD {
	std::vector< unsigned char > code;
	std::string s_name;
};

static const std::vector< CBASIC_RESERVED_WORD > reserved_words = {
	{ { 0x8C },				"RESTORE" },
	{ { 0xE3 },				"STRING$" },
	{ { 0xBC },				"CIRCLE" },
	{ { 0xE8 },				"CSRLIN" },
	{ { 0xAE },				"DEFDBL" },
	{ { 0xAC },				"DEFINT" },
	{ { 0xAD },				"DEFSNG" },
	{ { 0xAB },				"DEFSTR" },
	{ { 0xA8 },				"DELETE" },
	{ { 0xEC },				"INKEY$" },
	{ { 0xBB },				"LFILES" },
	{ { 0xD8 },				"LOCATE" },
	{ { 0x9D },				"LPRINT" },
	{ { 0xC3 },				"PRESET" },
	{ { 0xA7 },				"RESUME" },
	{ { 0x8E },				"RETURN" },
	{ { 0xFF, 0x82 },		"RIGHT$" },
	{ { 0xC5 },				"SCREEN" },
	{ { 0xFF, 0x99 },		"SPACE$" },
	{ { 0xC7 },				"SPRITE" },
	{ { 0xE7 },				"VARPTR" },
	{ { 0xE9 },				"ATTR$" },
	{ { 0xCF },				"BLOAD" },
	{ { 0xD0 },				"BSAVE" },
	{ { 0x92 },				"CLEAR" },
	{ { 0x9B },				"CLOAD" },
	{ { 0xB4 },				"CLOSE" },
	{ { 0xBD },				"COLOR" },
	{ { 0x9A },				"CSAVE" },
	{ { 0xA5 },				"ERASE" },
	{ { 0xA6 },				"ERROR" },
	{ { 0xB1 },				"FIELD" },
	{ { 0xB7 },				"FILES" },
	{ { 0x8D },				"GOSUB" },
	{ { 0x85 },				"INPUT" },
	{ { 0xE5 },				"INSTR" },
	{ { 0x9E },				"LLIST" },
	{ { 0xB6 },				"MERGE" },
	{ { 0xCD },				"MOTOR" },
	{ { 0xBF },				"PAINT" },
	{ { 0xED },				"POINT" },
	{ { 0x91 },				"PRINT" },
	{ { 0xAA },				"RENUM" },
	{ { 0xC4 },				"SOUND" },
	{ { 0xA3 },				"TROFF" },
	{ { 0xE4 },				"USING" },
	{ { 0xFF, 0x98 },		"VPEEK" },
	{ { 0xC6 },				"VPOKE" },
	{ { 0xA0 },				"WIDTH" },
	{ { 0xFF, 0xA2 },		"STICK" },
	{ { 0xFF, 0xA3 },		"STRIG" },
	{ { 0xA9 },				"AUTO" },
	{ { 0xC9 },				"BASE" },
	{ { 0xC0 },				"BEEP" },
	{ { 0xCA },				"CALL" },
	{ { 0xFF, 0xA0 },		"CDBL" },
	{ { 0xFF, 0x96 },		"CHR$" },
	{ { 0xFF, 0x9D },		"BIN$" },
	{ { 0x99 },				"CONT" },
	{ { 0xD6 },				"COPY" },
	{ { 0xBE },				"DRAW" },
	{ { 0xFF, 0xA6 },		"DSKF" },
	{ { 0xEA },				"DSKI$" },
	{ { 0xD1 },				"DSKO$" },
	{ { 0x3A, 0xA1 },		"ELSE" },
	{ { 0xFF, 0x9F },		"CSNG" },
	{ { 0x84 },				"DATA" },
	{ { 0xFF, 0xA7 },		"FPOS" },
	{ { 0x89 },				"GOTO" },
	{ { 0xFF, 0x9B },		"HEX$" },
	{ { 0xD4 },				"KILL" },
	{ { 0xFF, 0x81 },		"LEFT$" },
	{ { 0xAF },				"LINE" },
	{ { 0x93 },				"LIST" },
	{ { 0xB5 },				"LOAD" },
	{ { 0xFF, 0x9C },		"LPOS" },
	{ { 0xB8 },				"LSET" },
	{ { 0xFF, 0x83 },		"MID$" },
	{ { 0xFF, 0xB0 },		"MKD$" },
	{ { 0xFF, 0xAE },		"MKI$" },
	{ { 0xFF, 0xAF },		"MKS$" },
	{ { 0xD3 },				"NAME" },
	{ { 0x83 },				"NEXT" },
	{ { 0xFF, 0x9A },		"OCT$" },
	{ { 0xB0 },				"OPEN" },
	{ { 0xFF, 0x97 },		"PEEK" },
	{ { 0xC1 },				"PLAY" },
	{ { 0x98 },				"POKE" },
	{ { 0xC2 },				"PSET" },
	{ { 0x87 },				"READ" },
	{ { 0xB9 },				"RSET" },
	{ { 0xBA },				"SAVE" },
	{ { 0xDF },				"SPC(" },
	{ { 0xDC },				"STEP" },
	{ { 0x90 },				"STOP" },
	{ { 0xFF, 0x93 },		"STR$" },
	{ { 0xA4 },				"SWAP" },
	{ { 0xDB },				"TAB(" },
	{ { 0xDA },				"THEN" },
	{ { 0xCB },				"TIME" },
	{ { 0xA2 },				"TRON" },
	{ { 0x96 },				"WAIT" },
	{ { 0xF8 },				"XOR" },
	{ { 0xC8 },				"VDP" },
	{ { 0xDD },				"USR" },
	{ { 0xFF, 0x94 },		"VAL" },
	{ { 0xFF, 0x86 },		"ABS" },
	{ { 0xF6 },				"AND" },
	{ { 0xFF, 0x95 },		"ASC" },
	{ { 0xFF, 0x38 },		"ATN" },
	{ { 0xFF, 0x9E },		"CNT" },
	{ { 0x9F },				"CLS" },
	{ { 0xD7 },				"CMD" },
	{ { 0xFF, 0x8C },		"COS" },
	{ { 0xFF, 0xAA },		"CVD" },
	{ { 0xFF, 0xA8 },		"CVI" },
	{ { 0xFF, 0xA9 },		"CVS" },
	{ { 0x97 },				"DEF" },
	{ { 0x86 },				"DIM" },
	{ { 0x81 },				"END" },
	{ { 0xFF, 0xAB },		"EOF" },
	{ { 0xF9 },				"EQV" },
	{ { 0xE1 },				"ERL" },
	{ { 0xE2 },				"ERR" },
	{ { 0xFF, 0x8B },		"EXP" },
	{ { 0xFF, 0xA1 },		"FIX" },
	{ { 0x82 },				"FOR" },
	{ { 0xFF, 0x8F },		"FRE" },
	{ { 0xB2 },				"GET" },
	{ { 0xFA },				"INP" },
	{ { 0xFF, 0x90 },		"INP" },
	{ { 0xFF, 0x85 },		"INT" },
	{ { 0xD5 },				"IPL" },
	{ { 0xCC },				"KEY" },
	{ { 0xFF, 0x92 },		"LEN" },
	{ { 0x88 },				"LET" },
	{ { 0xFF, 0xAC },		"LOC" },
	{ { 0xFF, 0xAD },		"LOF" },
	{ { 0xFF, 0x8A },		"LOG" },
	{ { 0xCD },				"MAX" },
	{ { 0xFB },				"MOD" },
	{ { 0x94 },				"NEW" },
	{ { 0xE0 },				"NOT" },
	{ { 0xEB },				"OFF" },
	{ { 0x9C },				"OUT" },
	{ { 0xFF, 0xA5 },		"PAD" },
	{ { 0xFF, 0xA4 },		"PDL" },
	{ { 0xFF, 0x91 },		"POS" },
	{ { 0xB3 },				"PUT" },
	{ { 0x8F },				"REM" },
	{ { 0xFF, 0x88 },		"RND" },
	{ { 0x8A },				"RUN" },
	{ { 0xD2 },				"SET" },
	{ { 0xFF, 0x84 },		"SGN" },
	{ { 0xFF, 0x89 },		"SIN" },
	{ { 0xFF, 0x87 },		"SQR" },
	{ { 0xFF, 0x8D },		"TAN" },
	{ { 0xD9 },				"TO" },
	{ { 0xDE },				"FN" },
	{ { 0x8B },				"IF" },
	{ { 0x95 },				"ON" },
	{ { 0xF7 },				"OR" },
	{ { 0xEE },				">" },
	{ { 0xEF },				"=" },
	{ { 0xF0 },				"<" },
	{ { 0xF1 },				"+" },
	{ { 0xF2 },				"-" },
	{ { 0xF3 },				"*" },
	{ { 0xF4 },				"/" },
	{ { 0xF5 },				"^" },
	{ { 0xFC },				"\\" },
	{ { 0x3A, 0x8F, 0xE6 },	"'" },
};

// --------------------------------------------------------------------
//	中間言語形式(バイナリファイル)か、ASCIIセーブ形式かを判定する
//	中間言語形式であれば true を返す
bool CBASIC_LIST::check_binary_program( FILE *p_file ) {

	return( *(this->p_file_image) == 0xFF );
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load_file( FILE *p_file ) {
	long file_size, read_size;

	fseek( p_file, 0, SEEK_END );
	file_size = ftell( p_file );
	fseek( p_file, 0, SEEK_SET );

	file_image.resize( (size_t) file_size );
	read_size = (long) fread( file_image.data(), 1, file_size, p_file );
	
	this->p_file_image = file_image.begin();
	return( read_size == file_size );
}

// --------------------------------------------------------------------
int CBASIC_LIST::get_1byte( void ){
	int number;

	if( this->p_file_image == this->file_image.end() ){
		return 0;
	}
	number = *( this->p_file_image );
	this->p_file_image++;
	return number;
}

// --------------------------------------------------------------------
int CBASIC_LIST::get_2bytes( void ) {
	int number;

	if( this->p_file_image == this->file_image.end() ){
		return 0;
	}
	number = *(this->p_file_image);
	this->p_file_image++;
	if( this->p_file_image == this->file_image.end() ) {
		return number;
	}
	number += ((int) *(this->p_file_image)) << 8;
	this->p_file_image++;
	return number;
}

// --------------------------------------------------------------------
void CBASIC_LIST::skip_white_space( void ) {

	while( this->p_file_image != this->file_image.end() && (this->p_file_image[0] == ' ' || this->p_file_image[0] == '\t' || this->p_file_image[0] == '\r' || this->p_file_image[0] == 26) ) {
		this->p_file_image++;
	}
}

// --------------------------------------------------------------------
int CBASIC_LIST::get_integer( void ) {
	int number = 0;

	this->skip_white_space();
	while( this->p_file_image != this->file_image.end() && isdigit( this->p_file_image[0] & 255 ) ) {
		number = number * 10 + (int)(this->p_file_image[0] - '0');
		this->p_file_image++;
	}
	return number;
}

// --------------------------------------------------------------------
CBASIC_WORD CBASIC_LIST::get_word( void ) {
	int i, number;
	CBASIC_WORD s_word;

	//	スペースは読み飛ばす
	this->skip_white_space();
	if( *(this->p_file_image) == 0x0B || *( this->p_file_image ) == 0x0C || *( this->p_file_image ) == 0x1C ) {
		//	2byte の値だった場合
		this->p_file_image++;
		s_word.s_word = std::to_string( this->get_2bytes() );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	if( *( this->p_file_image ) == 0x0E ) {
		//	行番号だった場合
		this->p_file_image++;
		s_word.s_word = std::to_string( this->get_2bytes() );
		s_word.type = CBASIC_WORD_TYPE::LINE_NO;
		return s_word;
	}
	if( *( this->p_file_image ) == 0x0F ){
		//	1byte の値だった場合
		this->p_file_image++;
		s_word.s_word = std::to_string( this->get_1byte() );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	if( *( this->p_file_image ) >= 0x11 && *( this->p_file_image ) <= 0x1A ){
		//	1桁の数値だった場合
		s_word.s_word = std::to_string( *( this->p_file_image ) - 0x11 );
		this->p_file_image++;
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	if( *( this->p_file_image ) == 0x1D ) {
		//	単精度浮動小数点数だった場合
		//	★T.B.D.
		s_word.s_word = "0";
		s_word.type = CBASIC_WORD_TYPE::SINGLE_REAL;
		this->p_file_image += 5;
		return s_word;
	}
	if( *( this->p_file_image ) == 0x1F ){
		//	倍精度浮動小数点数だった場合
		//	★T.B.D.
		s_word.s_word = "0";
		s_word.type = CBASIC_WORD_TYPE::DOUBLE_REAL;
		this->p_file_image += 9;
		return s_word;
	}
	if( *( this->p_file_image ) == '"' ) {
		//	文字列だった場合
		s_word.s_word = "\"";
		s_word.type = CBASIC_WORD_TYPE::STRING;
		while( *(this->p_file_image) != '\"' && *(this->p_file_image) != 0 ){
			s_word.s_word = s_word.s_word + (char)*(this->p_file_image);
			this->p_file_image++;
		}
		return s_word;
	}
	if( this->p_file_image[0] == '&' && this->p_file_image[1] == 'B' ) {
		//	2進数だった場合
		number = 0;
		this->p_file_image += 2;
		while( *(this->p_file_image) == '0' || *(this->p_file_image) == '1' ) {
			number = (number << 1) | ( *(this->p_file_image) - '0' );
			this->p_file_image++;
		}
		s_word.s_word = std::to_string( number );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	//	一致する予約語コードがあるか調べる
	for( auto p = reserved_words.begin(); p != reserved_words.end(); p++ ) {
		i = 0;
		auto p_code = p->code.begin();
		for( ; p_code != p->code.end(); p_code++, i++ ) {
			if( this->p_file_image[i] != *p_code ) {
				break;
			}
		}
		if( p_code == p->code.end() ) {
			//	予約語コードと一致した場合、その予約語を返す
			this->p_file_image += i;
			s_word.s_word = p->s_name;
			s_word.type = CBASIC_WORD_TYPE::RESERVED_WORD;
			return s_word;
		}
	}
	//	予約語でない記号があるか調べる
	if( !isalpha(this->p_file_image[0] & 255) ) {
		s_word.s_word = (char)this->p_file_image[0];
		s_word.type = CBASIC_WORD_TYPE::SYMBOL;
		this->p_file_image++;
		return s_word;
	}
	//	変数名などアルファベットで始まる単語の場合
	s_word.s_word = "";
	s_word.type = CBASIC_WORD_TYPE::UNKNOWN_NAME;
	while( this->p_file_image != this->file_image.end() ) {
		if( isalpha(this->p_file_image[0] & 255) || isdigit(this->p_file_image[0] & 255) ) {
			s_word.s_word = s_word.s_word + (char)this->p_file_image[0];
		}
		else {
			break;
		}
		this->p_file_image++;
	}
	return s_word;
}

// --------------------------------------------------------------------
std::string CBASIC_LIST::get_word_in_charlist( const char *p_charlist ) {
	std::string s;

	while( this->p_file_image != this->file_image.end() && strchr( p_charlist, (char)this->p_file_image[0] ) != NULL ) {
		s = s + (char)this->p_file_image[0];
		this->p_file_image++;
	}
	return s;
}

// --------------------------------------------------------------------
CBASIC_WORD CBASIC_LIST::get_ascii_word( void ) {
	CBASIC_WORD s_word;
	std::string s;
	int i;

	//	スペースは読み飛ばす
	this->skip_white_space();
	if( this->p_file_image[0] == '&' && this->p_file_image[1] == 'B' ) {
		//	2進数の値だった場合
		this->p_file_image += 2;
		s = this->get_word_in_charlist( "01" );
		s_word.s_word = std::to_string( stoi( s, nullptr, 2 ) );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	if( this->p_file_image[0] == '&' && this->p_file_image[1] == 'O' ) {
		//	8進数の値だった場合
		this->p_file_image += 2;
		s = this->get_word_in_charlist( "01234567" );
		s_word.s_word = std::to_string( stoi( s, nullptr, 8 ) );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	if( this->p_file_image[0] == '&' && this->p_file_image[1] == 'H' ) {
		//	16進数の値だった場合
		this->p_file_image += 2;
		s = this->get_word_in_charlist( "0123456789abcdefABCDEF" );
		s_word.s_word = std::to_string( stoi( s, nullptr, 16 ) );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	if( isdigit( this->p_file_image[0] & 255 ) ) {
		//	10進数の値だった場合
		s = this->get_word_in_charlist( "0123456789" );
		s_word.s_word = std::to_string( stoi( s, nullptr, 10 ) );
		s_word.type = CBASIC_WORD_TYPE::INTEGER;
		return s_word;
	}
	//	一致する予約語コードがあるか調べる
	for( auto p = reserved_words.begin(); p != reserved_words.end(); p++ ) {
		i = 0;
		auto p_name = p->s_name.begin();
		for( ; p_name != p->s_name.end(); p_name++, i++ ) {
			if( this->p_file_image[i] != *p_name ) {
				break;
			}
		}
		if( p_name == p->s_name.end() ) {
			//	予約語コードと一致した場合、その予約語を返す
			this->p_file_image += i;
			s_word.s_word = p->s_name;
			s_word.type = CBASIC_WORD_TYPE::RESERVED_WORD;
			return s_word;
		}
	}
	//	予約語でない記号があるか調べる
	if( !isalpha(this->p_file_image[0] & 255) ) {
		s_word.s_word = (char)this->p_file_image[0];
		s_word.type = CBASIC_WORD_TYPE::SYMBOL;
		this->p_file_image++;
		return s_word;
	}
	//	変数名などアルファベットで始まる単語の場合
	s_word.s_word = "";
	s_word.type = CBASIC_WORD_TYPE::UNKNOWN_NAME;
	while( this->p_file_image != this->file_image.end() ) {
		if( isalpha(this->p_file_image[0] & 255) || isdigit(this->p_file_image[0] & 255) ) {
			s_word.s_word = s_word.s_word + (char)this->p_file_image[0];
		}
		else {
			break;
		}
		this->p_file_image++;
	}
	return s_word;
}

// --------------------------------------------------------------------
CBASIC_WORD CBASIC_LIST::get_comment( void ) {
	CBASIC_WORD s_word;

	s_word.s_word = "";
	s_word.type = CBASIC_WORD_TYPE::COMMENT;
	while( this->p_file_image != this->file_image.end() && this->p_file_image[0] != 0 && this->p_file_image[0] != '\n' ) {
		if( this->p_file_image[0] != '\r' ) {
			s_word.s_word = s_word.s_word + (char)this->p_file_image[0];
		}
		this->p_file_image++;
	}
	return s_word;
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load_binary( FILE *p_file ) {
	int next_address;
	CBASIC_WORD s_word;

	//	skip 0xFF
	this->p_file_image++;

	while( this->p_file_image != this->file_image.end() ) {
		//	次の行のアドレスと行番号 を取得
		next_address = this->get_2bytes();
		if( next_address == 0 ) {
			//	終わり
			break;
		}
		line_no = this->get_2bytes();
		//	行内の解釈
		while( this->p_file_image != this->file_image.end() && (this->p_file_image[0] != 0) ) {
			//	単語を1つ取得して、行番号を付与してリストに追加
			s_word = this->get_word();
			s_word.line_no = line_no;
			this->words.push_back( s_word );
			if( s_word.s_word == "'" || s_word.s_word == "REM" ) {
				this->skip_white_space();
				s_word = this->get_comment();
				s_word.line_no = line_no;
				this->words.push_back( s_word );
				break;
			}
		}
		if( this->p_file_image == this->file_image.end() ) {
			//	行の端末コードが無い
			this->errors.add( "Cannot find terminator code.", line_no );
			return false;
		}
		this->p_file_image++;
	}
	return true;
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load_ascii( FILE *p_file ) {
	CBASIC_WORD s_word;
	bool is_last_jump = false;

	while( this->p_file_image != this->file_image.end() ) {
		//	行番号を得る
		line_no = this->get_integer();
		//	行内の解釈
		while( this->p_file_image != this->file_image.end() && this->p_file_image[0] != '\n' ) {
			//	単語を1つ取得して、行番号を付与してリストに追加
			s_word = this->get_ascii_word();
			s_word.line_no = line_no;
			if( is_last_jump ) {
				if( s_word.type == CBASIC_WORD_TYPE::INTEGER ) {
					s_word.type = CBASIC_WORD_TYPE::LINE_NO;
				}
				else if( s_word.s_word != "," && s_word.type == CBASIC_WORD_TYPE::RESERVED_WORD ) {
					is_last_jump = false;
				}
			}
			else {
				if( s_word.s_word == "GOTO" || s_word.s_word == "GOSUB" || s_word.s_word == "THEN" || s_word.s_word == "ELSE" ) {
					is_last_jump = true;
				}
			}
			this->words.push_back( s_word );
			this->skip_white_space();
			if( s_word.s_word == "'" || s_word.s_word == "REM" ) {
				s_word = this->get_comment();
				s_word.line_no = line_no;
				this->words.push_back( s_word );
				break;
			}
		}
		is_last_jump = false;
		if( this->p_file_image == this->file_image.end() ) {
			break;
		}
		if( this->p_file_image[0] == '\n' ) {
			this->p_file_image++;
		}
	}
	return true;
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load( const std::string &s_file_name ) {
	FILE *p_in;
	bool result;

	fopen_s( &p_in, s_file_name.c_str(), "rb" );
	if( p_in == NULL ) {
		this->s_error_message = "Cannot open the input file (" + s_file_name + ").";
		return false;
	}
	if( !this->load_file( p_in ) ){
		this->s_error_message = "Cannot read the input file (" + s_file_name + ").";
		return false;
	}

	if( this->check_binary_program( p_in ) ) {
		result = this->load_binary( p_in );
	}
	else {
		result = this->load_ascii( p_in );
	}
	fclose( p_in );
	return result;
}
