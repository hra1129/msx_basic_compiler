// --------------------------------------------------------------------
//	MSX-BASIC code loader
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#ifndef __BASIC_TYPES_H__
#define __BASIC_TYPES_H__

// --------------------------------------------------------------------
enum class CEXPRESSION_TYPE: int {
	UNKNOWN = 0,
	INTEGER = 1,
	SINGLE_REAL = 2,
	DOUBLE_REAL = 3,
	STRING = 4,
	EXTENDED_INTEGER = 5,	//	※ CEXPRESSION::convert_type() の target としてのみ指定可能 -32768～65535 を 2byte整数として扱う
};

// --------------------------------------------------------------------
enum class CBASIC_WORD_TYPE {
	UNKNOWN,					//	0:未知
	UNKNOWN_NAME,			//	1:何かの名前
	SYMBOL,					//	2:記号
	INTEGER,				//	3:整数
	SINGLE_REAL,			//	4:単精度実数
	DOUBLE_REAL,			//	5:倍精度実数
	STRING,					//	6:文字列
	RESERVED_WORD,			//	7:予約語
	LINE_NO,				//	8:行番号
	COMMENT,				//	9:コメント
};

// --------------------------------------------------------------------
enum class CTARGET_TYPES {
	MSX1,
	MSX2,
	MSX2P,
	MSXTR,
};

// --------------------------------------------------------------------
enum class COPTIMIZE_LEVEL: int {
	NONE = 0,
	NODE_ONLY = 1,
	CODE = 2,
	DEEP = 3,
};

// --------------------------------------------------------------------
enum class CCOMPILE_MODE: int {
	COMPATIBLE = 0,
	ORIGINAL = 1,
};

// --------------------------------------------------------------------
class COPTIONS {
public:
	std::string s_input_name;
	std::string s_output_name;
	int start_address;
	int stack_size;

	CTARGET_TYPES target_type;
	COPTIMIZE_LEVEL optimize_level;
	CCOMPILE_MODE compile_mode;

	COPTIONS() {
		this->target_type = CTARGET_TYPES::MSX1;
		this->start_address = 0x8010;
		this->stack_size = 256;
		this->optimize_level = COPTIMIZE_LEVEL::CODE;
		this->compile_mode = CCOMPILE_MODE::COMPATIBLE;
	}

	bool parse_options( char *argv[], int argc );
};

#endif
