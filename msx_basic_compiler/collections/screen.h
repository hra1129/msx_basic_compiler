// --------------------------------------------------------------------
//	Compiler collection: Screen
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SCREEN_H__
#define __SCREEN_H__

class CSCREEN: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
