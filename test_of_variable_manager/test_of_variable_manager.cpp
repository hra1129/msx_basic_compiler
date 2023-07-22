// --------------------------------------------------------------------
//	CVARIABLE_MANAGER のテスト
// ====================================================================
//	2023/July/22nd	t.hara
// --------------------------------------------------------------------

#include "../unit_test/unit_test.h"
#include "../msx_basic_compiler/basic_code_loader.h"
#include "../msx_basic_compiler/variable_manager.h"

int main( int argc, char *argv[] ) {
	CUNIT_TEST test;
	CBASIC_LIST list_test001_bas;
	CVARIABLE_MANAGER vman;
	std::vector< CVARIABLE_TYPE > def_types;
	int i;

	test.success_condition_is( list_test001_bas.load( "./test/type.bas" ), "./test/type.bas を読み込み、true が返る", __LINE__ );

	def_types = vman.get_def_types();
	for( i = 0; i < 26; i++ ) {
		test.success_condition_is( def_types[i] == CVARIABLE_TYPE::DOUBLE_REAL, std::to_string( (char)(i + 'A') ) + " はデフォルトでは倍精度実数である", __LINE__ );
	}

	test.success_condition_is( vman.analyze_defvars( list_test001_bas.get_word_list() ), "analyze_defvars() で true が返る", __LINE__ );

	def_types = vman.get_def_types();
	test.success_condition_is( def_types['A'-'A'] == CVARIABLE_TYPE::INTEGER, "A は INT である", __LINE__ );
	test.success_condition_is( def_types['B'-'A'] == CVARIABLE_TYPE::INTEGER, "B は INT である", __LINE__ );
	test.success_condition_is( def_types['C'-'A'] == CVARIABLE_TYPE::SINGLE_REAL, "C は SNG である", __LINE__ );
	test.success_condition_is( def_types['D'-'A'] == CVARIABLE_TYPE::SINGLE_REAL, "D は SNG である", __LINE__ );
	test.success_condition_is( def_types['E'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "E は DBL である", __LINE__ );
	test.success_condition_is( def_types['F'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "F は DBL である", __LINE__ );
	test.success_condition_is( def_types['G'-'A'] == CVARIABLE_TYPE::STRING, "G は STR である", __LINE__ );
	test.success_condition_is( def_types['H'-'A'] == CVARIABLE_TYPE::STRING, "H は STR である", __LINE__ );
	test.success_condition_is( def_types['I'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "I は DBL である", __LINE__ );
	test.success_condition_is( def_types['J'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "J は DBL である", __LINE__ );
	test.success_condition_is( def_types['K'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "K は DBL である", __LINE__ );
	test.success_condition_is( def_types['L'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "L は DBL である", __LINE__ );
	test.success_condition_is( def_types['M'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "M は DBL である", __LINE__ );
	test.success_condition_is( def_types['N'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "N は DBL である", __LINE__ );
	test.success_condition_is( def_types['O'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "O は DBL である", __LINE__ );
	test.success_condition_is( def_types['P'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "P は DBL である", __LINE__ );
	test.success_condition_is( def_types['Q'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "Q は DBL である", __LINE__ );
	test.success_condition_is( def_types['R'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "R は DBL である", __LINE__ );
	test.success_condition_is( def_types['S'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "S は DBL である", __LINE__ );
	test.success_condition_is( def_types['T'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "T は DBL である", __LINE__ );
	test.success_condition_is( def_types['U'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "U は DBL である", __LINE__ );
	test.success_condition_is( def_types['V'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "V は DBL である", __LINE__ );
	test.success_condition_is( def_types['W'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "W は DBL である", __LINE__ );
	test.success_condition_is( def_types['X'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "X は DBL である", __LINE__ );
	test.success_condition_is( def_types['Y'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "Y は DBL である", __LINE__ );
	test.success_condition_is( def_types['Z'-'A'] == CVARIABLE_TYPE::DOUBLE_REAL, "Z は DBL である", __LINE__ );
	return 0;
}
