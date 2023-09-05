// --------------------------------------------------------------------
//	Compiler collection: Sound
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SOUND_H__
#define __SOUND_H__

class CSOUND: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
