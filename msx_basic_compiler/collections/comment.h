// --------------------------------------------------------------------
//	Compiler collection: Comment
// ====================================================================
//	2023/July/24th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __COMMENT_H__
#define __COMMENT_H__

class CCOMMENT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
