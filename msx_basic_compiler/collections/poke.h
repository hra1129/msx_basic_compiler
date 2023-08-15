// --------------------------------------------------------------------
//	Compiler collection: Poke
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __POKE_H__
#define __POKE_H__

class CPOKE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
