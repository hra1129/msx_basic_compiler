// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "error_list.h"
#include <cstdio>
#include <map>
#include <string>

static std::map< int, std::string > error_name = {
	{ SYNTAX_ERROR, "Syntax error." },
	{ MISSING_OPERAND, "Missing operand." },
	{ ILLEGAL_FUNCTION_CALL, "Illegal function call." },
	{ REDIMENSIONED_ARRAY, "Redimensioned array." },
	{ TYPE_MISMATCH, "Type mismatch." },
	{ UNDIFINED_LINE_NUMBER, "Undifined line number." },
};

// --------------------------------------------------------------------
void CERROR_LIST::add( std::string s_error, int line_no ) {
	std::string s;

	if( line_no ) {
		s = "ERROR(" + std::to_string( line_no ) + "): " + s_error;
	}
	else {
		s = "ERROR: " + s_error;
	}
	this->list.push_back( s );
}

// --------------------------------------------------------------------
void CERROR_LIST::add( CERROR_ID error, int line_no ) {

	this->add( error_name[ error ], line_no );
}

// --------------------------------------------------------------------
void CERROR_LIST::print( void ) {

	for( auto &p: this->list ) {
		fprintf( stderr, "%s\n", p.c_str() );
	}
}
