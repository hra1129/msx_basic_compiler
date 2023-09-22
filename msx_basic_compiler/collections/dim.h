// --------------------------------------------------------------------
//	Compiler collection: Dim
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DIM_H__
#define __DIM_H__

class CDIM: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
