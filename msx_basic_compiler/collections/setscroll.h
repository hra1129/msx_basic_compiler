// --------------------------------------------------------------------
//	Compiler collection: SetScroll
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETSCROLL_H__
#define __SETSCROLL_H__

class CSETSCROLL: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
