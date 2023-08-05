// --------------------------------------------------------------------
//	Compiler collection: Comment
// ====================================================================
//	2023/July/24th	t.hara
// --------------------------------------------------------------------
#pragma once

#include "../compiler.h"

class CCOMMENT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};
