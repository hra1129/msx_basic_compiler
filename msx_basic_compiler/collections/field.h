// --------------------------------------------------------------------
//	Compiler collection: Field
// ====================================================================
//	2024/Aprl/23th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __FIELD_H__
#define __FIELD_H__

class CFIELD: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
