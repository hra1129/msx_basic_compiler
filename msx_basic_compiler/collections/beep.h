// --------------------------------------------------------------------
//	Compiler collection: Beep
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __BEEP_H__
#define __BEEP_H__

class CBEEP: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
