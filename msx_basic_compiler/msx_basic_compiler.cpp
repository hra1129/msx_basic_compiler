// --------------------------------------------------------------------
//  MSX-BASIC Compiler
// ====================================================================
//  2023/July/19th  t.hara
// --------------------------------------------------------------------

#include <cstdio>
#include <string>
#include "compiler.h"

static const char *s_version = "v0.0";

// --------------------------------------------------------------------
static void usage( const char *p_name ) {

	fprintf( stderr, "Usage> %s [options] <input.bas> <output.asm>\n", p_name );
	fprintf( stderr, "\n" );
	fprintf( stderr, "  [options]\n" );
	fprintf( stderr, "  Output types.\n" );
	fprintf( stderr, "    -zma .......... Output files are ZMA type assembly language. (default)\n" );
	fprintf( stderr, "    -m80 .......... Output files are M80 type assembly language.\n" );
	fprintf( stderr, "  Compile mode.\n" );
	fprintf( stderr, "    -compatible ... Mode for compatibility with MSX-BASIC.\n" );
	fprintf( stderr, "    -original ..... MSX-BACON Extension Mode.\n" );
	fprintf( stderr, "  Target types.\n" );
	fprintf( stderr, "    -msx .......... MSX1 (default)\n");
	fprintf( stderr, "    -msx2 ......... MSX2\n");
	fprintf( stderr, "    -msx2p ........ MSX2+\n");
	fprintf( stderr, "    -msxtr ........ MSXturboR\n");
	fprintf( stderr, "  Optimization levels.\n" );
	fprintf( stderr, "    -O0 ........... No optimization is performed.\n");
	fprintf( stderr, "    -O1 ........... Only pre-calculation of arithmetic nodes.\n");
	fprintf( stderr, "    -O2 ........... It also reconstructs the generated code.\n");
	fprintf( stderr, "    -O3 ........... Maximum optimization.\n");
	fprintf( stderr, "  Start address.\n" );
	fprintf( stderr, "    -start n ...... Starting address of program code. (Default: 0x8010)\n" );
	fprintf( stderr, "  Stack size.\n" );
	fprintf( stderr, "    -stack n ...... Call stack size. (Default: 256)\n" );
}

// --------------------------------------------------------------------
bool COPTIONS::parse_options( char *argv[], int argc ) {
	bool result = false;
	std::string s;

	this->s_input_name = "";
	this->s_output_name = "";
	for( int i = 1; i < argc; i++ ) {
		s = argv[i];
		if( s[0] == '-' ) {
			if( s == "-O0" ) {
				this->optimize_level = COPTIMIZE_LEVEL::NONE;
			}
			else if( s == "-O1" ) {
				this->optimize_level = COPTIMIZE_LEVEL::NODE_ONLY;
			}
			else if( s == "-O2" ) {
				this->optimize_level = COPTIMIZE_LEVEL::CODE;
			}
			else if( s == "-O3" ) {
				this->optimize_level = COPTIMIZE_LEVEL::DEEP;
			}
			else if( s == "-start" && (i + 1) != argc ) {
				this->start_address = atoi( argv[i + 1] );
				if( this->start_address < 32768 ) {
					this->start_address = 32768;
				}
				else if( this->start_address > 65535 ) {
					this->start_address = 65535;
				}
			}
			else if( s == "-stack" && (i + 1) != argc ) {
				this->stack_size = atoi( argv[i + 1] );
				if( this->stack_size < 0 ) {
					this->stack_size = 0;
				}
				else if( this->stack_size > 16384 ) {
					this->stack_size = 16384;
				}
				this->stack_size &= ~1;
			}
			else if( s == "-compatible" ) {
				this->compile_mode = CCOMPILE_MODE::COMPATIBLE;
			}
			else if( s == "-original" ) {
				this->compile_mode = CCOMPILE_MODE::ORIGINAL;
			}
			else {
				fprintf( stderr, "ERROR: Unknown option '%s'.\n", s.c_str() );
				exit(1);
			}
		}
		else {
			if( this->s_input_name == "" ) {
				this->s_input_name = s;
			}
			else if( this->s_output_name == "" ) {
				this->s_output_name = s;
				result = true;
			}
			else {
				result = false;
				break;
			}
		}
	}
	if( !result ) {
		usage( argv[0] );
		exit(1);
	}
	switch( this->compile_mode ) {
	case CCOMPILE_MODE::COMPATIBLE:
		printf( "  Compile mode: MSX-BASIC Compatible.\n" );
		break;
	case CCOMPILE_MODE::ORIGINAL:
		printf( "  Compile mode: MSX-BACON Extension.\n" );
		break;
	}
	switch( this->optimize_level ) {
	case COPTIMIZE_LEVEL::NONE:
		printf( "  Optimization level: O0 (None)\n" );
		break;
	case COPTIMIZE_LEVEL::NODE_ONLY:
		printf( "  Optimization level: O1 (Node Only)\n" );
		break;
	case COPTIMIZE_LEVEL::CODE:
		printf( "  Optimization level: O2 (Code)\n" );
		break;
	case COPTIMIZE_LEVEL::DEEP:
		printf( "  Optimization level: O3 (Deep)\n" );
		break;
	}
	printf( "  Start address : 0x%04X\n", this->start_address );
	printf( "  Stack size    : %d\n", this->stack_size );
	return result;
}

// --------------------------------------------------------------------
int main( int argc, char *argv[] ) {
	CCOMPILER compiler;

	printf( "MSX-BACON %s\n", s_version );
	printf( "=========================================================\n" );
	printf( "Copyright (C)2023 t.hara\n" );

	if( !compiler.info.options.parse_options( argv, argc ) ) {
		return 1;
	}

	if( !compiler.info.list.load( compiler.info.options.s_input_name, compiler.info.errors ) ) {
		compiler.info.errors.print();
		fprintf( stderr, "ERROR: Processing cannot continue because the file failed to load.\n" );
		return 2;
	}
	printf( "\n" );
	printf( "Target: %s (%s).\n", compiler.info.options.s_input_name.c_str(), compiler.info.list.s_source_type.c_str() );

	compiler.exec( compiler.info.options.s_input_name );
	compiler.info.errors.print();
	if( compiler.info.errors.list.size() ) {
		printf( "Found %d error(s).\n", (int)compiler.info.errors.list.size() );
		return 1;
	}
	if( !compiler.info.assembler_list.save( compiler.info.options.s_output_name ) ) {
		return 2;
	}
	printf( "Completed.\n" );
	return 0;
}
