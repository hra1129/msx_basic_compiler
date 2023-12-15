// --------------------------------------------------------------------
//	Compiler collection: VPokes
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __VPOKES_H__
#define __VPOKES_H__

class CVPOKES: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
