// --------------------------------------------------------------------
//	MSX-BASIC •¶Žš—ñ
// ====================================================================
//	2023/Aug/16th  t.hara 
// --------------------------------------------------------------------

#include <string>

#ifndef __STRING_VALUE_H__
#define __STRING_VALUE_H__

class CSTRING {
public:
	int reference_count = 0;

	size_t length = 0;
	char image[ 256 ] = {};

	bool set( std::string s );
	bool set( int length, const char *p_image );
};

#endif
