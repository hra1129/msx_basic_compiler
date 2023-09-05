// --------------------------------------------------------------------
//	Compiler collection: Defstr
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DEFSTR_H__
#define __DEFSTR_H__

class CDEFSTR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
