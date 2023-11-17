// --------------------------------------------------------------------
//	Compiler collection: Bload
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __BLOAD_H__
#define __BLOAD_H__

class CBLOAD: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
