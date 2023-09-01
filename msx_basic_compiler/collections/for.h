// --------------------------------------------------------------------
//	Compiler collection: For
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __FOR_H__
#define __FOR_H__

class CFOR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
