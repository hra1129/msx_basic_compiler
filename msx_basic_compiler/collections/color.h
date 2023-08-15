// --------------------------------------------------------------------
//	Compiler collection: Color
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __COLOR_H__
#define __COLOR_H__

class CCOLOR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
