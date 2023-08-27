// --------------------------------------------------------------------
//	Compiler collection: If
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __IF_H__
#define __IF_H__

class CIF: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
