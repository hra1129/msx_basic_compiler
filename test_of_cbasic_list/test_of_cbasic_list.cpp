// --------------------------------------------------------------------
//	CBASIC_LIST のテスト
// ====================================================================
//	2023/July/22nd	t.hara
// --------------------------------------------------------------------

#include "../unit_test/unit_test.h"
#include "../msx_basic_compiler/basic_code_loader.h"

struct CREFERENCE {
	int line_no;
	const char *p_word;
	CBASIC_WORD_TYPE type;
};

std::vector< CREFERENCE > test001 = {
	{ 100, "A", CBASIC_WORD_TYPE::UNKNOWN_NAME },
	{ 100, "$", CBASIC_WORD_TYPE::SYMBOL },
	{ 100, "=", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 100, "SPC(", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 100, "10", CBASIC_WORD_TYPE::INTEGER },
	{ 100, ")", CBASIC_WORD_TYPE::SYMBOL },
	{ 100, "+", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 100, "TAB(", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 100, "10", CBASIC_WORD_TYPE::INTEGER },
	{ 100, ")", CBASIC_WORD_TYPE::SYMBOL },
	{ 110, "A", CBASIC_WORD_TYPE::UNKNOWN_NAME },
	{ 110, "=", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 110, "B", CBASIC_WORD_TYPE::UNKNOWN_NAME },
	{ 110, "+", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 110, "1", CBASIC_WORD_TYPE::INTEGER },
	{ 120, "'", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 120, "A=B+2", CBASIC_WORD_TYPE::COMMENT },
	{ 130, "GOTO", CBASIC_WORD_TYPE::RESERVED_WORD },
	{ 130, "100", CBASIC_WORD_TYPE::LINE_NO },
};

// --------------------------------------------------------------------
int main( int argc, char *argv[] ) {
	CUNIT_TEST test;
	CBASIC_LIST list_test001_bas;
	CBASIC_LIST list_test001_asc;
	CBASIC_LIST list_fail;
	std::vector< CBASIC_WORD > words;
	int i;

	printf( "test001.bas ---------------\n" );
	test.success_condition_is( list_test001_bas.load( "./test/test001.bas" ), "./test/test001.bas を読み込み、true が返る", __LINE__ );

	words = list_test001_bas.get_word_list();
	i = 0;
	test.success_condition_is( words.size() == test001.size(), "words のサイズ" + std::to_string(words.size()) + "は、test001 のサイズ" + std::to_string(test001.size()) + "と一致する", __LINE__ );
	if( words.size() == test001.size() ) {
		for( auto &p: test001 ) {
			test.success_condition_is( words[i].line_no == p.line_no, std::to_string(i+1) + "番目の単語は " + std::to_string( test001[i].line_no ) + "行目にある", __LINE__ );
			test.success_condition_is( words[i].s_word  == p.p_word, std::to_string(i+1)  + "番目の単語は " + p.p_word + " である (" + words[i].s_word + ")", __LINE__ );
			test.success_condition_is( words[i].type    == p.type, std::to_string(i+1)    + "番目の単語は " + std::to_string( int(p.type) ) + " である (" + std::to_string( int(words[i].type) ) + ")", __LINE__ );
			i++;
		}
	}

	printf( "test001.asc ---------------\n" );
	test.success_condition_is( list_test001_asc.load( "./test/test001.asc" ), "./test/test001.asc を読み込み、true が返る", __LINE__ );

	words = list_test001_asc.get_word_list();
	i = 0;
	test.success_condition_is( words.size() == test001.size(), "words のサイズ" + std::to_string(words.size()) + "は、test001 のサイズ" + std::to_string(test001.size()) + "と一致する", __LINE__ );
	if( words.size() == test001.size() ) {
		for( auto &p: test001 ) {
			test.success_condition_is( words[i].line_no == p.line_no, std::to_string(i+1) + "番目の単語は " + std::to_string( test001[i].line_no ) + "行目にある", __LINE__ );
			test.success_condition_is( words[i].s_word  == p.p_word, std::to_string(i+1)  + "番目の単語は " + p.p_word + " である (" + words[i].s_word + ")", __LINE__ );
			test.success_condition_is( words[i].type    == p.type, std::to_string(i+1)    + "番目の単語は " + std::to_string( int(p.type) ) + " である (" + std::to_string( int(words[i].type) ) + ")", __LINE__ );
			i++;
		}
	}
	printf( "fail test -----------------\n" );
	test.success_condition_is( !list_fail.load( "./****" ), "存在しないファイル名を指定して、false が返る", __LINE__ );

	return 0;
}
