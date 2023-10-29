// --------------------------------------------------------------------
//	Compiler collection: Play
// ====================================================================
//	2023/Aug/11th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PLAY_H__
#define __PLAY_H__

class CPLAY: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
