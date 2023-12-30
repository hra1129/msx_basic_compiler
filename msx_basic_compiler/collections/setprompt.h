// --------------------------------------------------------------------
//	Compiler collection: SetPrompt
// ====================================================================
//	2023/Dec/30th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETPROMPT_H__
#define __SETPROMPT_H__

class CSETPROMPT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
