// --------------------------------------------------------------------
//	単体テスト
// ====================================================================
//	2023/July/22rd	t.hara
// --------------------------------------------------------------------

#pragma once

#include <cstdio>
#include <string>

class CUNIT_TEST {
private:
	int test_count;
	int error_count;

public:
	CUNIT_TEST(): test_count(0), error_count(0) {
		printf( "<< START UNIT TEST >>\n" );
	}

	~CUNIT_TEST() {
		printf( "<< END OF UNIT TEST >>\n" );
		if( test_count != 0 && error_count == 0 ) {
			printf( "SUCCESS OF ALL!! (%d test(s))\n", test_count );
		}
		else if( test_count == 0 ) {
			printf( "FAILED!!: The test is not running at all.\n" );
		}
		else {
			printf( "FAILED!!: %d test(s) were performed and %d error(s) occurred.\n", test_count, error_count );
		}
	}

	void success_condition_is( bool condition, std::string s_error_message, int line_no ) {
		test_count++;
		if( !condition ) {
			error_count++;
			printf( "ERROR(%4d): %s\n", line_no, s_error_message.c_str() );
		}
	}
};
