// --------------------------------------------------------------------
//	Compiler collection: Clear
// ====================================================================
//	2023/Nov/26th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __CLEAR_H__
#define __CLEAR_H__

class CCLEAR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
