// --------------------------------------------------------------------
//	Compiler collection: Defdbl
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DEFDBL_H__
#define __DEFFBL_H__

class CDEFDBL: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
