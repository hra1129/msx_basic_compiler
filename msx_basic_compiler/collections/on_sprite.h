// --------------------------------------------------------------------
//	Compiler collection: On Sprite
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ON_SPRITE_H__
#define __ON_SPRITE_H__

class CONSPRITE: public CCOMPILER_CONTAINER {
private:
	void sprite( CCOMPILE_INFO *p_info );

public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
