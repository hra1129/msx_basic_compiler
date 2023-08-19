// --------------------------------------------------------------------
//	Compiler collection: Vpoke
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __VPOKE_H__
#define __VPOKE_H__

class CVPOKE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
