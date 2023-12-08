// --------------------------------------------------------------------
//	Compiler collection: Pokew
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __POKEW_H__
#define __POKEW_H__

class CPOKEW: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
