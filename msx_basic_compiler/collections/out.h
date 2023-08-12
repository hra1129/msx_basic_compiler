// --------------------------------------------------------------------
//	Compiler collection: Out
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#pragma once

#include "../compiler.h"

class COUT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};
