// --------------------------------------------------------------------
//	MSX-BASIC î{ê∏ìxìxé¿êî
// ====================================================================
//	2023/Aug/14th  t.hara 
// --------------------------------------------------------------------

#include <string>

#ifndef __DOUBLE_REAL_H__
#define __DOUBLE_REAL_H__

class CDOUBLE_REAL {
public:
	int reference_count = 0;

	unsigned char image[ 8 ] = {};

	bool set( std::string s );
};

#endif
