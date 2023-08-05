// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <vector>
#include "assembler_line.h"
#include "../basic_types.h"

#ifndef __ASSEMBLER_LIST_H__
#define __ASSEMBLER_LIST_H__

class CASSEMBLER_LIST {
public:
	std::vector< CASSEMBLER_LINE >		header;
	std::vector< CASSEMBLER_LINE >		body;
	std::vector< CASSEMBLER_LINE >		datas;
	std::vector< CASSEMBLER_LINE >		variables_area;
	std::vector< CASSEMBLER_LINE >		footer;

	bool save( const std::string s_file_name, COUTPUT_TYPES output_type );
};

#endif
