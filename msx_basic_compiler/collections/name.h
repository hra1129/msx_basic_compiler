// --------------------------------------------------------------------
//	Compiler collection: Name
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __NAME_H__
#define __NAME_H__

class CNAME: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
