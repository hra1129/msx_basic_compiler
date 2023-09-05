// --------------------------------------------------------------------
//	Compiler collection: Next
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __NEXT_H__
#define __NEXT_H__

class CNEXT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
