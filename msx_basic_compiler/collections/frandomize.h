// --------------------------------------------------------------------
//	Compiler collection: FRandomize
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __FRANDOMIZE_H__
#define __FRANDOMIZE_H__

class CFRANDOMIZE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
