// --------------------------------------------------------------------
//	Compiler collection: Defsng
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DEFSNG_H__
#define __DEFSNG_H__

class CDEFSNG: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
