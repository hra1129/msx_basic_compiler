// --------------------------------------------------------------------
//	Compiler collection: Pokes
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __POKES_H__
#define __POKES_H__

class CPOKES: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
