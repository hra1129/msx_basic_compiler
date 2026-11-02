// --------------------------------------------------------------------
//	Compiler collection: Draw
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DRAW_H__
#define __DRAW_H__

class CDRAW: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
