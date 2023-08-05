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
enum class COUTPUT_TYPES {
	ZMA,
	M80,
};

// --------------------------------------------------------------------
class COPTIONS {
public:
	std::string s_input_name;
	std::string s_output_name;

	COUTPUT_TYPES output_type;

	COPTIONS() {
		this->output_type = COUTPUT_TYPES::ZMA;
	}

	bool parse_options( char *argv[], int argc );
};

// --------------------------------------------------------------------
static void usage( const char *p_name ) {

	fprintf( stderr, "Usage> %s [options] <input.bas> <output.asm>\n", p_name );
	fprintf( stderr, "\n" );
	fprintf( stderr, "  [options]\n" );
	fprintf( stderr, "  Output types.\n" );
	fprintf( stderr, "    -zma ..... Output files are ZMA type assembly language. (default)\n" );
	fprintf( stderr, "    -m80 ..... Output files are M80 type assembly language.\n" );
}

// --------------------------------------------------------------------
bool COPTIONS::parse_options( char *argv[], int argc ) {
	bool result = false;
	std::string s;

	this->s_input_name = "";
	this->s_output_name = "";
	for( int i = 1; i < argc; i++ ) {
		s = argv[i];
		if( s[0] == '-' || s[0] == '/' ) {
			if( s == "-zma" ) {
				this->output_type = COUTPUT_TYPES::ZMA;
			}
			else if( s == "-m80" ) {
				this->output_type = COUTPUT_TYPES::M80;
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
	return result;
}

// --------------------------------------------------------------------
int main( int argc, char *argv[] ) {
	COPTIONS options;
	CCOMPILER compiler;

	printf( "MSX-BASIC Compiler %s\n", s_version );
	printf( "=========================================================\n" );
	printf( "Copyright (C)2023 t.hara\n" );

	if( !options.parse_options( argv, argc ) ) {
		return 1;
	}

	if( !compiler.info.list.load( options.s_input_name, compiler.info.errors ) ) {

	}

	return 0;
}