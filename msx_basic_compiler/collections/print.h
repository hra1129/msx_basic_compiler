// --------------------------------------------------------------------
//	Compiler collection: Print
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PRINT_H__
#define __PRINT_H__

class CPRINT: public CCOMPILER_CONTAINER {
private:
	bool exec_using( CCOMPILE_INFO *p_info, bool is_file );

public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
