// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include "basic_code_loader.h"

struct CBASIC_RESERVED_WORD {
	std::vector< unsigned char > code;
	std::string s_name;
};

static CBASIC_RESERVED_WORD reserved_words[] = {
	{ { 0xEE }, ">" },
	{ { 0xEF }, "=" },
	{ { 0xF0 }, "<" },
	{ { 0xF1 }, "+" },
	{ { 0xF2 }, "-" },
	{ { 0xF3 }, "*" },
	{ { 0xF4 }, "/" },
	{ { 0xF5 }, "^" },
	{ { 0xFC }, "\\" },
	{ {	0xFF, 0x86 }, "ABS" },
	{ { 0xF6 }, "AND" },
	{ { 0xFF, 0x95 }, "ASC" },
	{ { 0xFF, 0x38 }, "ATN" },
	{ { 0xE9 }, "ATTR$" },
	{ { 0xA9 }, "AUTO" },
	{ { 0xC9 }, "BASE" },
	{ { 0xC0 }, "BEEP" },
	{ { 0xFF, 0x9D }, "BIN$" },
	{ { 0xCF }, "BLOAD" },
	{ { 0xD0 }, "BSAVE" },
	{ { 0xCA }, "CALL" },
	{ { 0xFF, 0xA0 }, "CDBL" },
	{ { 0xFF, 0x96 }, "CHR$" },
	{ { 0xFF, 0x9E }, "CNT" },
	{ { 0xBC }, "CIRCLE" },
	{ { 0x92 }, "CLEAR" },
	{ { 0x9B }, "CLOAD" },
	{ { 0xB4 }, "CLOSE" },
	{ { 0x9F }, "CLS" },
	{ { 0xD7 }, "CMD" },
	{ { 0xBD }, "COLOR" },
	{ { 0x99 }, "CONT" },
	{ { 0xD6 }, "COPY" },
	{ { 0xFF, 0x8C }, "COS" },
	{ { 0x9A }, "CSAVE" },
	{ { 0xFF, 0x9F }, "CSNG" },
	{ { 0xE8 }, "CSRLIN" },
	{ { 0xFF, 0xAA }, "CVD" },
	{ { 0xFF, 0xA8 }, "CVI" },
	{ { 0xFF, 0xA9 }, "CVS" },
	{ { 0x84 }, "DATA" },
	{ { 0x97 }, "DEF" },
	{ { 0xAE }, "DEFDBL" },
	{ { 0xAC }, "DEFINT" },
	{ { 0xAD }, "DEFSGN" },
	{ { 0xAB }, "DEFSTR" },
	{ { 0xA8 }, "DELETE" },
	{ { 0x86 }, "DIM" },
	{ { 0xBE }, "DRAW" },
	{ { 0xFF, 0xA6 }, "DSKF" },
	{ { 0xEA }, "DSKI$" },
	{ { 0xD1 }, "DSKO$" },
	{ { 0x3A, 0xA1 }, "ELSE" },
	{ { 0x81 }, "END" },
	{ { 0xFF, 0xAB }, "EOF" },
	{ { 0xF9 }, "EQV" },
	{ { 0xA5 }, "ERASE" },
	{ { 0xE1 }, "ERL" },
	{ { 0xE2 }, "ERR" },
	{ { 0xA6 }, "ERROR" },
	{ { 0xFF, 0x8B }, "EXP" },
	{ { 0xB1 }, "FIELD" },
	{ { 0xB7 }, "FILES" },
	{ { 0xFF, 0xA1 }, "FIX" },
	{ { 0xDE }, "FN" },
	{ { 0x82 }, "FOR" },
	{ { 0xFF, 0xA7 }, "FPOS" },
	{ { 0xFF, 0x8F }, "FRE" },
	{ { 0xB2 }, "GET" },
	{ { 0x8D }, "GOSUB" },
	{ { 0x89 }, "GOTO" },
	{ { 0xFF, 0x9B }, "HEX$" },
	{ { 0x8B }, "IF" },
	{ { 0xFA }, "INP" },
	{ { 0xEC }, "INKEY$" },
	{ { 0xFF, 0x90 }, "INP" },
	{ { 0x85 }, "INPUT" },
	{ { 0xE5 }, "INSTR" },
	{ { 0xFF, 0x85 }, "INT" },
	{ { 0xD5 }, "IPL" },
	{ { 0xCC }, "KEY" },
	{ { 0xD4 }, "KILL" },
	{ { 0xFF, 0x81 }, "LEFT$" },
	{ { 0xFF, 0x92 }, "LEN" },
	{ { 0x88 }, "LET" },
	{ { 0xBB }, "LFILES" },
	{ { 0xAF }, "LINE" },
	{ { 0x93 }, "LIST" },
	{ { 0x9E }, "LLIST" },
	{ { 0xB5 }, "LOAD" },
	{ { 0xFF, 0xAC }, "LOC" },
	{ { 0xD8 }, "LOCATE" },
	{ { 0xFF, 0xAD }, "LOF" },
	{ { 0xFF, 0x8A }, "LOG" },
	{ { 0xFF, 0x9C }, "LPOS" },
	{ { 0x9D }, "LPRINT" },
	{ { 0xB8 }, "LSET" },
	{ { 0xCD }, "MAX" },
	{ { 0xB6 }, "MERGE" },
	{ { 0xFF, 0x83 }, "MID$" },
	{ { 0xFF, 0xB0 }, "MKD$" },
	{ { 0xFF, 0xAE }, "MKI$" },
	{ { 0xFF, 0xAF }, "MKS$" },
	{ { 0xFB }, "MOD" },
	{ { 0xCD }, "MOTOR" },
	{ { 0xD3 }, "NAME" },
	{ { 0x94 }, "NEW" },
	{ { 0x83 }, "NEXT" },
	{ { 0xE0 }, "NOT" },
	{ { 0xFF, 0x9A }, "OCT$" },
	{ { 0xEB }, "OFF" },
	{ { 0x95 }, "ON" },
	{ { 0xB0 }, "OPEN" },
	{ { 0xF7 }, "OR" },
	{ { 0x9C }, "OUT" },
	{ { 0xFF, 0xA5 }, "PAD" },
	{ { 0xBF }, "PAINT" },
	{ { 0xFF, 0xA4 }, "PDL" },
	{ { 0xFF, 0x97 }, "PEEK" },
	{ { 0xC1 }, "PLAY" },
	{ { 0xED }, "POINT" },
	{ { 0x98 }, "POKE" },
	{ { 0xFF, 0x91 }, "POS" },
	{ { 0xC3 }, "PRESET" },
	{ { 0x91 }, "PRINT" },
	{ { 0xC2 }, "PSET" },
	{ { 0xB3 }, "PUT" },
	{ { 0x87 }, "READ" },
	{ { 0x8F }, "REM" },
	{ { 0xAA }, "RENUM" },
	{ { 0x8C }, "RESTORE" },
	{ { 0xA7 }, "RESUME" },
	{ { 0x8E }, "RETURN" },
	{ { 0xFF, 0x82 }, "RIGHT$" },
	{ { 0xFF, 0x88 }, "RND" },
	{ { 0xB9 }, "RSET" },
	{ { 0x8A }, "RUN" },
	{ { 0xBA }, "SAVE" },
	{ { 0xC5 }, "SCREEN" },
	{ { 0xD2 }, "SET" },
	{ { 0xFF, 0x84 }, "SGN" },
	{ { 0xFF, 0x89 }, "SIN" },
	{ { 0xC4 }, "SOUND" },
	{ { 0xFF, 0x99 }, "SPACE$" },
	{ { 0xDF }, "SPC (" },
	{ { 0xC7 }, "SPRITE" },
	{ { 0xFF, 0x87 }, "SQR" },
	{ { 0xDC }, "STEP" },
	{ { 0xFF, 0xA2 }, "STICK" },
	{ { 0x90 }, "STOP" },
	{ { 0xFF, 0x93 }, "STR$" },
	{ { 0xFF, 0xA3 }, "STRIG" },
	{ { 0xE3 }, "STRING$" },
	{ { 0xA4 }, "SWAP" },
	{ { 0xDB }, "TAB (" },
	{ { 0xFF, 0x8D }, "TAN" },
	{ { 0xDA }, "THEN" },
	{ { 0xCB }, "TIME" },
	{ { 0xD9 }, "TO" },
	{ { 0xA3 }, "TROFF" },
	{ { 0xA2 }, "TRON" },
	{ { 0xE4 }, "USING" },
	{ { 0xDD }, "USR" },
	{ { 0xFF, 0x94 }, "VAL" },
	{ { 0xE7 }, "VARPTR" },
	{ { 0xC8 }, "VDP" },
	{ { 0xFF, 0x98 }, "VPEEK" },
	{ { 0xC6 }, "VPOKE" },
	{ { 0x96 }, "WAIT" },
	{ { 0xA0 }, "WIDTH" },
	{ { 0xF8 }, "XOR" },
	{ { 0x3A, 0x8F, 0xE6 }, "'" },
};

// --------------------------------------------------------------------
//	中間言語形式(バイナリファイル)か、ASCIIセーブ形式かを判定する
//	中間言語形式であれば true を返す
bool CBASIC_LIST::check_binary_program( FILE *p_file ) {
	long position;
	char code = 0xFF;

	position = ftell( p_file );
	fseek( p_file, 0, SEEK_SET );
	fread( &code, 1, 1, p_file );
	fseek( p_file, position, SEEK_SET );

	return( code == 0xFF );
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load_binary( FILE *p_file ) {
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load_ascii( FILE *p_file ) {
}

// --------------------------------------------------------------------
bool CBASIC_LIST::load( const std::string &s_file_name ) {
	FILE *p_in;

	p_in = fopen( s_file_name.c_str(), "rb" );
	if( p_in == NULL ) {
		
		return false;
	}
	if( this->check_binary_program( p_in ) ) {
		return this->load_binary( p_in );
	}
	else {
		return this->load_ascii( p_in );
	}
}
