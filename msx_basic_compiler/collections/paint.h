// --------------------------------------------------------------------
//	Compiler collection: Paint
// ====================================================================
//	2023/Dec/29th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PAINT_H__
#define __PAINT_H__

class CPAINT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
