// --------------------------------------------------------------------
//	Compiler collection: Out
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __OUT_H__
#define __OUT_H__

class COUT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
