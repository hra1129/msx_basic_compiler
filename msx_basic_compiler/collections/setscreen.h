// --------------------------------------------------------------------
//	Compiler collection: SetScreen
// ====================================================================
//	2023/Dec/30th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETSCREEN_H__
#define __SETSCREEN_H__

class CSETSCREEN: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
