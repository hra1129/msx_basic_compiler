// --------------------------------------------------------------------
//	Compiler collection: Pset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PSET_H__
#define __PSET_H__

class CPSET: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
