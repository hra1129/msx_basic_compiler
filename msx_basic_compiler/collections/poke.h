// --------------------------------------------------------------------
//	Compiler collection: Poke
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#pragma once

#include "../compiler.h"

class CPOKE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};
