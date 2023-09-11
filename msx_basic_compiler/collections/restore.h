// --------------------------------------------------------------------
//	Compiler collection: Restore
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __RESTORE_H__
#define __RESTORE_H__

class CRESTORE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
