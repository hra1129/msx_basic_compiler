// --------------------------------------------------------------------
//	Compiler collection: Cls
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __CLS_H__
#define __CLS_H__

class CCLS: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
