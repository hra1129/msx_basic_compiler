// --------------------------------------------------------------------
//	Compiler collection: Data
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DATA_H__
#define __DATA_H__

class CDATA: public CCOMPILER_CONTAINER {
private:
	int hexchar( int c );
	std::string hexdata( CCOMPILE_INFO *p_info, std::string s_data );
	std::string bindata( CCOMPILE_INFO *p_info, std::string s_data );
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
