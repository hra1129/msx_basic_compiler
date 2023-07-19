// --------------------------------------------------------------------
//  MSX-BASIC Compiler
// ====================================================================
//  2023/July/19th  t.hara
// --------------------------------------------------------------------

#include <cstdio>

static const char *s_version = "v0.0";

// --------------------------------------------------------------------
static void usage( const char *p_name ) {

	fprintf( stderr, "Usage> %s <input.bas> <output.com>\n", p_name );
}

// --------------------------------------------------------------------
int main( int argc, char *argv[] ) {

	printf( "MSX-BASIC Compiler %s\n", s_version );
	printf( "=========================================================\n" );
	printf( "Copyright (C)2023 t.hara\n" );

	if( argc != 3 ) {
		usage( argv[0] );
		return 1;
	}



	return 0;
}