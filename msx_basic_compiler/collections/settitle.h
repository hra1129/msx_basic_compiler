// --------------------------------------------------------------------
//	Compiler collection: SetTitle
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETTITLE_H__
#define __SETTITLE_H__

class CSETTITLE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
