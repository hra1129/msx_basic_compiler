// --------------------------------------------------------------------
//	Compiler collection: On Key
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ON_KEY_H__
#define __ON_KEY_H__

class CONKEY: public CCOMPILER_CONTAINER {
private:
	void strig( CCOMPILE_INFO *p_info );

public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
