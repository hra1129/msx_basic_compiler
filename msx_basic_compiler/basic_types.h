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
enum class COUTPUT_TYPES {
	ZMA,
	M80,
};

// --------------------------------------------------------------------
enum class CTARGET_TYPES {
	MSX1,
	MSX2,
	MSX2P,
	MSXTR,
};

// --------------------------------------------------------------------
class COPTIONS {
public:
	std::string s_input_name;
	std::string s_output_name;

	COUTPUT_TYPES output_type;
	CTARGET_TYPES target_type;

	COPTIONS() {
		this->output_type = COUTPUT_TYPES::ZMA;
		this->target_type = CTARGET_TYPES::MSX1;
	}

	bool parse_options( char *argv[], int argc );
};

#endif
