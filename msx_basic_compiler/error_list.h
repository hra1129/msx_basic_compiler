// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>

class CERROR_LIST {
public:
	std::vector< std::string > list;

	void add( std::string s_error, int line_no );
};