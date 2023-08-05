// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>

#ifndef __CERROR_LIST_H__
#define __CERROR_LIST_H__

class CERROR_LIST {
public:
	std::vector< std::string > list;

	void add( std::string s_error, int line_no );
};

#endif
