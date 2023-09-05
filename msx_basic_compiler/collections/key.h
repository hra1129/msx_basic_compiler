// --------------------------------------------------------------------
//	Compiler collection: Key
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __KEY_H__
#define __KEY_H__

class CKEY: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
