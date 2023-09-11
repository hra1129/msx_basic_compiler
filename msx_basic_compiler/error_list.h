// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>

#ifndef __CERROR_LIST_H__
#define __CERROR_LIST_H__

enum CERROR_ID: int {
	NO_ERROR,
	SYNTAX_ERROR,
	MISSING_OPERAND,
	ILLEGAL_FUNCTION_CALL,
	REDIMENSIONED_ARRAY,
	TYPE_MISMATCH,
	UNDIFINED_LINE_NUMBER,
};

class CERROR_LIST {
public:
	std::vector< std::string > list;

	void add( std::string s_error, int line_no );
	void add( CERROR_ID error, int line_no );
	void print( void );
};

#endif
