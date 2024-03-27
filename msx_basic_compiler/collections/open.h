// --------------------------------------------------------------------
//	Compiler collection: Open
// ====================================================================
//	2024/Mar/26th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __OPEN_H__
#define __OPEN_H__

class COPEN: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
