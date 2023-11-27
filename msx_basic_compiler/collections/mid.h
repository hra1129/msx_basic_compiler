// --------------------------------------------------------------------
//	Compiler collection: Mid$
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __MID_H__
#define __MID_H__

class CMID: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
