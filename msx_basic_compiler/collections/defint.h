// --------------------------------------------------------------------
//	Compiler collection: Defint
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DEFINT_H__
#define __DEFINT_H__

class CDEFINT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
