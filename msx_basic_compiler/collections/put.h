// --------------------------------------------------------------------
//	Compiler collection: Put
// ====================================================================
//	2024/Aprl/23th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PUT_H__
#define __PUT_H__

class CPUT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
