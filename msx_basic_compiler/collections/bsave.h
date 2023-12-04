// --------------------------------------------------------------------
//	Compiler collection: Bsave
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __BSAVE_H__
#define __BSAVE_H__

class CBSAVE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
