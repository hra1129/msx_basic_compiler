// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include "basic_list.h"
#include "single_real.h"
#include "double_real.h"
#include <cstring>
#include <cmath>

struct CBASIC_RESERVED_WORD {
	std::vector< int > code;
	std::string s_name;
};

static const std::vector< CBASIC_RESERVED_WORD > reserved_words = {
	{ { -1 },				"FRANDOMIZE" },
	{ { -1 },				"INTERVAL" },
	{ { -1 },				"CHRHEX$" },
	{ { -1 },				"HEXCHR$" },
	{ { 0x8C },				"RESTORE" },
	{ { 0xE3 },				"STRING$" },
	{ { -1 },				"VPEEKS$" },
	{ { 0xBC },				"CIRCLE" },
	{ { 0xE8 },				"CSRLIN" },
	{ { 0xAE },				"DEFDBL" },
	{ { 0xAC },				"DEFINT" },
	{ { 0xAD },				"DEFSNG" },
	{ { 0xAB },				"DEFSTR" },
	{ { 0xA8 },				"DELETE" },
	{ { 0xEC },				"INKEY$" },
	{ { -1 },				"INPUT$" },
	{ { 0xBB },				"LFILES" },
	{ { 0xD8 },				"LOCATE" },
	{ { 0x9D },				"LPRINT" },
	{ { 0xC3 },				"PRESET" },
	{ { 0xA7 },				"RESUME" },
	{ { 0x8E },				"RETURN" },
	{ { 0xFF, 0x82 },		"RIGHT$" },
	{ { 0xC5 },				"SCREEN" },
	{ { -1 },				"SCROLL" },
	{ { 0xFF, 0x99 },		"SPACE$" },
	{ { 0xC7 },				"SPRITE" },
	{ { 0xE7 },				"VARPTR" },
	{ { -1 },				"PEEKS$" },
	{ { -1 },				"VPOKES" },
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
	{ { -1 },				"PEEKW"	},
	{ { -1 },				"POKEW"	},
	{ { -1 },				"POKES"	},
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
	{ { 0xEA },				"DSKI$" },
	{ { 0xD1 },				"DSKO$" },
	{ { 0xFF, 0x81 },		"LEFT$" },
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
	{ { 0x3A, 0xA1 },		"ELSE" },
	{ { 0xFF, 0x9F },		"CSNG" },
	{ { 0x84 },				"DATA" },
	{ { 0xFF, 0xA7 },		"FPOS" },
	{ { -1 },				"FRND" },
	{ { 0x89 },				"GOTO" },
	{ { 0xFF, 0x9B },		"HEX$" },
	{ { 0xD4 },				"KILL" },
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
	{ { -1 },				"PAGE" },
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
	{ { 0xFA },				"IMP" },
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
bool CBASIC_LIST::is_end( void ) {

	return( this->p_position == this->words.end() );
}

// --------------------------------------------------------------------
bool CBASIC_LIST::is_line_end( void ) {

	if( this->p_position == this->words.end() ) {
		return true;
	}
	return( this->current_line_no != this->p_position->line_no );
}

// --------------------------------------------------------------------
bool CBASIC_LIST::is_command_end( void ) {

	if( this->is_line_end() ) {
		return true;
	}
	return( this->p_position->type != CBASIC_WORD_TYPE::STRING && (this->p_position->s_word == ":" || this->p_position->s_word == "'" || this->p_position->s_word == "ELSE" || this->p_position->s_word == "REM") );
}

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
	char s[32];

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
		number = this->get_2bytes();
		s_word.s_word = std::to_string( number );
		s_word.type = CBASIC_WORD_TYPE::LINE_NO;
		this->jump_target_line_no.push_back( number );
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
		this->p_file_image++;
		s_word.s_word = "";
		for( i = 0; i < 4; i++ ) {
			sprintf( s, "%02X", this->p_file_image[0] );
			s_word.s_word = s_word.s_word + s;
			this->p_file_image++;
		}
		s_word.type = CBASIC_WORD_TYPE::SINGLE_REAL;
		return s_word;
	}
	if( *( this->p_file_image ) == 0x1F ){
		//	倍精度浮動小数点数だった場合
		this->p_file_image++;
		s_word.s_word = "";
		for( i = 0; i < 4; i++ ) {
			sprintf( s, "%02X", this->p_file_image[0] );
			s_word.s_word = s_word.s_word + s;
			this->p_file_image++;
		}
		s_word.type = CBASIC_WORD_TYPE::DOUBLE_REAL;
		return s_word;
	}
	if( *( this->p_file_image ) == '"' ) {
		//	文字列だった場合
		s_word.s_word = "";
		s_word.type = CBASIC_WORD_TYPE::STRING;
		this->p_file_image++;
		while( *(this->p_file_image) != '\"' && *(this->p_file_image) != 0 ){
			s_word.s_word = s_word.s_word + (char)*(this->p_file_image);
			this->p_file_image++;
		}
		if( *(this->p_file_image) == '\"' ) {
			this->p_file_image++;
		}
		return s_word;
	}
	if( this->p_file_image[0] == '&' ) {
		this->skip_white_space();
		if( this->p_file_image[0] == 'B' ) {
			//	2進数だった場合
			number = 0;
			this->p_file_image++;
			while( *(this->p_file_image) == '0' || *(this->p_file_image) == '1' ) {
				number = (number << 1) | ( *(this->p_file_image) - '0' );
				this->p_file_image++;
			}
			s_word.s_word = std::to_string( number );
			s_word.type = CBASIC_WORD_TYPE::INTEGER;
			return s_word;
		}
		else {
			//	'&' だった場合
			s_word.s_word = '&';
			s_word.type = CBASIC_WORD_TYPE::SYMBOL;
			return s_word;
		}
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
bool CBASIC_LIST::check_word( CERROR_LIST *p_error, std::string s, CERROR_ID error_id ) {

	if( this->is_command_end() || this->p_position->s_word != s ) {
		p_error->add( error_id, this->get_line_no() );	//	あるべき閉じ括弧
		return false;
	}
	this->p_position++;
	return true;
}

// --------------------------------------------------------------------
CBASIC_WORD CBASIC_LIST::get_decimal( const std::string s, const std::string s_type ) {
	CBASIC_WORD s_word;
	bool is_real = false;
	int decimal;

	s_word.line_no = this->get_line_no();
	//	浮動小数点数か否か
	for( auto c: s ) {
		if( c == '.' || c == 'E' || c == '!' || c == '#' ) {
			is_real = true;
			break;
		}
	}
	if( s_type == "%" ) {
		is_real = false;
	}
	if( s_type == "!" || s_type == "#" ) {
		is_real = true;
	}
	if( !is_real ) {
		//	整数の範囲に収まるか？
		double d = 0.;
		double a = .1;
		auto p = s.begin();
		int sign = 0;
		int exp = 0;
		//	仮数部の整数部
		while( p != s.end() && isdigit( *p & 255 ) ) {
			d = d * 10. + (*p - '0');
			p++;
		}
		if( p != s.end() && *p == '.' ) {
			//	仮数部の小数部
			p++;
			while( p != s.end() && isdigit( *p & 255 ) ) {
				d = d + (*p - '0') * a;
				a = a / 10.;
				p++;
			}
		}
		if( p != s.end() && *p == 'E' ) {
			//	指数部
			p++;
			if( p != s.end() && *p == '-' ) {
				sign = -1;
			}
			else {
				sign = 1;
			}
			while( p != s.end() && isdigit( *p & 255 ) ) {
				exp = exp * 10 + (*p - '0');
				p++;
			}
			d = d * pow( 10., sign * exp );
		}
		decimal = int( d );
		if( s.size() < 5 || (s.size() == 5 && decimal < 32768) ) {
			//	整数確定
			s_word.s_word = std::to_string( decimal );
			s_word.type = CBASIC_WORD_TYPE::INTEGER;
			return s_word;
		}
	}
	//	実数表現だった場合
	CDOUBLE_REAL v;
	v.set( s );
	s_word.s_word = s;
	if( v.image[4] == 0 && v.image[5] == 0 && v.image[6] == 0 && v.image[7] == 0 ) {
		s_word.type = CBASIC_WORD_TYPE::SINGLE_REAL;
	}
	else {
		s_word.type = CBASIC_WORD_TYPE::DOUBLE_REAL;
	}
	return s_word;
}

// --------------------------------------------------------------------
std::string CBASIC_LIST::get_word_in_charlist( const char *p_charlist, bool ignore_space ) {
	std::string s;

	this->skip_white_space();
	while( this->p_file_image != this->file_image.end() && strchr( p_charlist, (char)this->p_file_image[0] ) != NULL ) {
		s = s + (char)this->p_file_image[0];
		this->p_file_image++;
	}
	return s;
}

// --------------------------------------------------------------------
std::string CBASIC_LIST::get_char_in_charlist( const char *p_charlist, bool ignore_space ) {
	std::string s;

	this->skip_white_space();
	if( this->p_file_image != this->file_image.end() && strchr( p_charlist, (char)this->p_file_image[0] ) != NULL ) {
		s = s + (char)this->p_file_image[0];
		this->p_file_image++;
	}
	return s;
}

// --------------------------------------------------------------------
CBASIC_WORD CBASIC_LIST::get_data_word( void ) {
	CBASIC_WORD s_word;
	std::string s;

	this->skip_white_space();
	s_word.line_no = this->line_no;

	//	データのライン番号を登録する
	bool has_line_no = false;
	for( auto i: this->data_line_no ) {
		if( i == this->line_no ) {
			has_line_no = true;
			break;
		}
	}
	if( !has_line_no ) {
		this->data_line_no.push_back( this->line_no );
	}

	if( this->p_file_image == this->file_image.end() ) {
		s_word.s_word = "";
		s_word.type = CBASIC_WORD_TYPE::UNKNOWN;
		return s_word;
	}
	if( this->p_file_image[0] == '"' ) {
		//	" で始まる場合
		this->p_file_image++;
		while( this->p_file_image != this->file_image.end() && this->p_file_image[0] != '"' && this->p_file_image[0] != '\r' && this->p_file_image[0] != '\n' && this->p_file_image[0] != '\0' ) {
			s = s + (char)this->p_file_image[0];
			this->p_file_image++;
		}
		if( this->p_file_image != this->file_image.end() && this->p_file_image[0] == '"' ) {
			this->p_file_image++;
		}
	}
	else {
		//	" が無い場合
		while( this->p_file_image != this->file_image.end() && this->p_file_image[0] != ':' && this->p_file_image[0] != ',' && this->p_file_image[0] != '\r' && this->p_file_image[0] != '\n' && this->p_file_image[0] != '\0' ) {
			s = s + (char)this->p_file_image[0];
			this->p_file_image++;
		}
	}
	s_word.s_word = s;
	s_word.type = CBASIC_WORD_TYPE::STRING;
	return s_word;
}

// --------------------------------------------------------------------
CBASIC_WORD CBASIC_LIST::get_ascii_word( bool label_ok ) {
	CBASIC_WORD s_word;
	std::string s;
	int i;

	this->skip_white_space();
	if( this->p_file_image == this->file_image.end() ) {
		s_word.s_word = "";
		s_word.type = CBASIC_WORD_TYPE::UNKNOWN;
		return s_word;
	}
	if( label_ok && this->p_file_image[0] == '*' ) {
		this->p_file_image++;
		s = "*";
		while( this->p_file_image != this->file_image.end() && (isalpha(this->p_file_image[0] & 255) || isdigit(this->p_file_image[0] & 255)) ) {
			s = s + (char)this->p_file_image[0];
			this->p_file_image++;
		}
		s_word.s_word = s;
		s_word.type = CBASIC_WORD_TYPE::LINE_NO;
		return s_word;
	}
	if( this->p_file_image[0] == '"' ) {
		this->p_file_image++;
		while( this->p_file_image != this->file_image.end() && this->p_file_image[0] != '"' && this->p_file_image[0] != '\r' && this->p_file_image[0] != '\n' ) {
			s = s + (char)this->p_file_image[0];
			this->p_file_image++;
		}
		if( this->p_file_image != this->file_image.end() && this->p_file_image[0] == '"' ) {
			this->p_file_image++;
		}
		s_word.s_word = s;
		s_word.type = CBASIC_WORD_TYPE::STRING;
		return s_word;
	}
	if( this->p_file_image[0] == '&' ) {
		this->p_file_image++;
		this->skip_white_space();
		if( this->p_file_image[0] == 'B' ) {
			//	2進数の値だった場合
			this->p_file_image++;
			s = this->get_word_in_charlist( "01" );
			s_word.s_word = std::to_string( stoi( s, nullptr, 2 ) );
			s_word.type = CBASIC_WORD_TYPE::INTEGER;
			return s_word;
		}
		if( this->p_file_image[0] == 'O' ) {
			//	8進数の値だった場合
			this->p_file_image++;
			s = this->get_word_in_charlist( "01234567" );
			s_word.s_word = std::to_string( stoi( s, nullptr, 8 ) );
			s_word.type = CBASIC_WORD_TYPE::INTEGER;
			return s_word;
		}
		if( this->p_file_image[0] == 'H' ) {
			//	16進数の値だった場合
			this->p_file_image++;
			s = this->get_word_in_charlist( "0123456789abcdefABCDEF" );
			s_word.s_word = std::to_string( stoi( s, nullptr, 16 ) );
			s_word.type = CBASIC_WORD_TYPE::INTEGER;
			return s_word;
		}
	}
	if( isdigit( this->p_file_image[0] & 255 ) || this->p_file_image[0] == '.' ) {
		//	10進数の値だった場合、整数・単精度実数・倍精度実数のどれか
		s = this->get_word_in_charlist( "0123456789", true );
		s = s + this->get_char_in_charlist( ".", true );
		s = s + this->get_word_in_charlist( "0123456789", true );
		if( this->p_file_image != this->file_image.end() && (toupper(this->p_file_image[0] & 255) == 'E' || toupper(this->p_file_image[0] & 255) == 'D') ) {
			this->p_file_image++;
			if( this->p_file_image != this->file_image.end() && (isdigit(this->p_file_image[0] & 255) || this->p_file_image[0] == '+' || this->p_file_image[0] == '-' || this->p_file_image[0] == '\r' || this->p_file_image[0] == '\n' || this->p_file_image[0] == ' ')) {
				s = s + "E";
				if( this->p_file_image != this->file_image.end() && (this->p_file_image[0] == '+' || this->p_file_image[0] == '-') ) {
					s = s + (char)this->p_file_image[0];
					this->p_file_image++;
				}
				s = s + this->get_word_in_charlist( "0123456789", true );
			}
			else {
				this->p_file_image--;
			}
		}
		std::string s_type = this->get_char_in_charlist( "!#%", true );
		s_word = this->get_decimal( s, s_type );
		return s_word;
	}
	//	一致する予約語コードがあるか調べる
	for( auto p = reserved_words.begin(); p != reserved_words.end(); p++ ) {
		i = 0;
		auto p_name = p->s_name.begin();
		for( ; p_name != p->s_name.end(); p_name++, i++ ) {
			if( toupper( this->p_file_image[i] & 255 ) != *p_name ) {
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
bool CBASIC_LIST::load_binary( FILE *p_file, CERROR_LIST &errors ) {
	int next_address;
	CBASIC_WORD s_word;
	bool is_data = false;

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
			if( !is_data && s_word.s_word == "DATA" && s_word.type == CBASIC_WORD_TYPE::RESERVED_WORD ) {
				is_data = true;
			}
			else if( is_data ) {
				this->skip_white_space();
				s_word = this->get_data_word();
				this->words.push_back( s_word );
				if( this->p_file_image != this->file_image.end() && (this->p_file_image[0] == ',') ) {
					this->p_file_image++;
					is_data = true;
				}
				else {
					is_data = false;
				}
			}
			else if( s_word.type == CBASIC_WORD_TYPE::RESERVED_WORD && (s_word.s_word == "'" || s_word.s_word == "REM") ) {
				this->skip_white_space();
				s_word = this->get_comment();
				s_word.line_no = line_no;
				this->words.push_back( s_word );
				break;
			}
		}
		if( this->p_file_image == this->file_image.end() ) {
			//	行の端末コードが無い
			errors.add( "Cannot find terminator code.", line_no );
			return false;
		}
		this->p_file_image++;
	}
	return true;
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load_ascii( FILE *p_file, CERROR_LIST &errors ) {
	CBASIC_WORD s_word;
	bool is_last_jump = false;
	bool is_data = false;
	bool label_ok = false;

	while( this->p_file_image != this->file_image.end() ) {
		//	行番号を得る
		line_no = this->get_integer();
		label_ok = true;
		//	行内の解釈
		while( this->p_file_image != this->file_image.end() && this->p_file_image[0] != '\n' ) {
			if( is_data ) {
				//	データを取得
				s_word = this->get_data_word();
				if( this->p_file_image != this->file_image.end() ) {
					if( this->p_file_image[0] == ',' ) {
						this->words.push_back( s_word );
						this->p_file_image++;

						s_word.s_word = ",";
						s_word.line_no = line_no;
						s_word.type = CBASIC_WORD_TYPE::RESERVED_WORD;
					}
					else {
						is_data = false;
					}
				}
				else {
					is_data = false;
				}
			}
			else {
				//	単語を1つ取得して、行番号を付与してリストに追加
				s_word = this->get_ascii_word( label_ok || is_last_jump );
				if( !(s_word.s_word == ":" && s_word.type == CBASIC_WORD_TYPE::SYMBOL) ) {
					label_ok = false;
				}
				s_word.line_no = line_no;
				if( is_last_jump ) {
					if( s_word.type == CBASIC_WORD_TYPE::INTEGER ) {
						s_word.type = CBASIC_WORD_TYPE::LINE_NO;
						this->jump_target_line_no.push_back( std::stoi( s_word.s_word ) );
					}
					else if( s_word.s_word == "ELSE" ) {
						is_last_jump = true;
					}
					else if( s_word.s_word == "," ) {
						is_last_jump = true;
					}
					else if( s_word.type == CBASIC_WORD_TYPE::RESERVED_WORD && (s_word.s_word == "RESTORE" || s_word.s_word == "RUN" || s_word.s_word == "GOTO" || s_word.s_word == "GOSUB" || s_word.s_word == "RETURN" || s_word.s_word == "ELSE") ) {
						is_last_jump = true;
					}
					else {
						is_last_jump = false;
					}
				}
				else {
					if( s_word.type == CBASIC_WORD_TYPE::RESERVED_WORD && (s_word.s_word == "RESTORE" || s_word.s_word == "RUN" || s_word.s_word == "GOTO" || s_word.s_word == "GOSUB" || s_word.s_word == "RETURN" || s_word.s_word == "THEN" || s_word.s_word == "ELSE") ) {
						is_last_jump = true;
					}
					else if( s_word.s_word == "DATA" && s_word.type == CBASIC_WORD_TYPE::RESERVED_WORD ) {
						is_data = true;
					}
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
			if( is_data ) {
				//	DATA hoge, のような場合にここに来る
				s_word.s_word = "";
				s_word.line_no = line_no;
				s_word.type = CBASIC_WORD_TYPE::STRING;
				this->words.push_back( s_word );
				is_data = false;
			}
		}
	}
	return true;
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load( const std::string &s_file_name, CERROR_LIST &errors ) {
	FILE *p_in;
	bool result;

	p_in = fopen( s_file_name.c_str(), "rb" );
	if( p_in == NULL ) {
		errors.add( "Cannot open the input file (" + s_file_name + ").", 0 );
		return false;
	}
	if( !this->load_file( p_in ) ){
		errors.add( "Cannot read the input file (" + s_file_name + ").", 0 );
		return false;
	}

	if( this->check_binary_program( p_in ) ) {
		this->s_source_type = "Precompiled code";
		result = this->load_binary( p_in, errors );
	}
	else {
		this->s_source_type = "ASCII code";
		result = this->load_ascii( p_in, errors );
	}
	fclose( p_in );
	return result;
}

// --------------------------------------------------------------------
void CBASIC_LIST::skip_statement( void ) {

	if( this->is_command_end() ) {
		return;
	}
	this->p_position++;
	while( !this->is_command_end() ) {
		this->p_position++;
	}
}
