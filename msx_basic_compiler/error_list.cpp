// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "error_list.h"
#include <cstdio>

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
void CERROR_LIST::print( void ) {

	for( auto &p: this->list ) {
		fprintf( stderr, "%s\n", p.c_str() );
	}
}
