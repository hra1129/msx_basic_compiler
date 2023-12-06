// --------------------------------------------------------------------
//	Compiler collection: Lset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __LSET_H__
#define __LSET_H__

class CLSET: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
