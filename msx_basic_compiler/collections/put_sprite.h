// --------------------------------------------------------------------
//	Compiler collection: Put Sprite
// ====================================================================
//	2023/Oct/21st	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PUT_SPRITE_H__
#define __PUT_SPRITE_H__

class CPUTSPRITE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
