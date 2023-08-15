// --------------------------------------------------------------------
//	Compiler collection: Gosub
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __GOSUB_H__
#define __GOSUB_H__

class CGOSUB: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
