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
	fprintf( stderr, "    -zma ..... Output files are ZMA type assembly language. (default)\n" );
	fprintf( stderr, "    -m80 ..... Output files are M80 type assembly language.\n" );
	fprintf( stderr, "  Target types.\n" );
	fprintf( stderr, "    -msx ..... MSX1 (default)\n");
	fprintf( stderr, "    -msx2 .... MSX2\n");
	fprintf( stderr, "    -msx2p ... MSX2+\n");
	fprintf( stderr, "    -msxtr ... MSXturboR\n");
	fprintf( stderr, "  Stack size.\n" );
	fprintf( stderr, "    -stack n . call stack size.\n" );
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
			if( s == "-zma" ) {
				this->output_type = COUTPUT_TYPES::ZMA;
			}
			else if( s == "-m80" ) {
				this->output_type = COUTPUT_TYPES::M80;
			}
			else if( s == "-msx" ) {
				this->target_type = CTARGET_TYPES::MSX1;
			}
			else if( s == "-msx2" ) {
				this->target_type = CTARGET_TYPES::MSX2;
			}
			else if( s == "-msx2p" ) {
				this->target_type = CTARGET_TYPES::MSX2P;
			}
			else if( s == "-msxtr" ) {
				this->target_type = CTARGET_TYPES::MSXTR;
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
	switch( this->output_type ) {
	default:
	case COUTPUT_TYPES::ZMA:
		printf( "  Output type: ZMA\n" );
		break;
	case COUTPUT_TYPES::M80:
		printf( "  Output type: M80\n" );
		break;
	}
	switch( this->target_type ) {
	case CTARGET_TYPES::MSX1:
		printf( "  Output type: MSX1\n" );
		break;
	case CTARGET_TYPES::MSX2:
		printf( "  Output type: MSX2\n" );
		break;
	case CTARGET_TYPES::MSX2P:
		printf( "  Output type: MSX2+\n" );
		break;
	case CTARGET_TYPES::MSXTR:
		printf( "  Output type: MSXturboR\n" );
		break;
	}
	printf( "  Stack size : %d", this->stack_size );
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
		//return 1;
	}
	if( !compiler.info.assembler_list.save( compiler.info.options.s_output_name, compiler.info.options.output_type ) ) {
		return 2;
	}
	printf( "Completed.\n" );
	return 0;
}
