// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <vector>
#include <cstdio>
#include "assembler_line.h"

#ifndef __ASSEMBLER_LIST_H__
#define __ASSEMBLER_LIST_H__

class CASSEMBLER_LIST {
private:
	std::vector< std::string >			label_list;

	bool save_sub( FILE *p_file, const std::vector< CASSEMBLER_LINE > *p_list, COUTPUT_TYPES output_type );

public:
	std::vector< CASSEMBLER_LINE >		header;
	std::vector< CASSEMBLER_LINE >		body;
	std::vector< CASSEMBLER_LINE >		subroutines;
	std::vector< CASSEMBLER_LINE >		datas;
	std::vector< CASSEMBLER_LINE >		const_single_area;
	std::vector< CASSEMBLER_LINE >		const_double_area;
	std::vector< CASSEMBLER_LINE >		variables_area;
	std::vector< CASSEMBLER_LINE >		footer;

	void add_label( const std::string s_name, const std::string s_value );

	bool save( const std::string s_file_name, COUTPUT_TYPES output_type );
};

#endif
