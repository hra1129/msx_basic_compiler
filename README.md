# msx_basic_compiler
MSX-BASICコンパイラ「BACON」

## 使用方法

MSX BASICのプログラム hello.bas を用意します
```basic
10 PRINT "HELLO! BACON"
20 GOTO 10
```

マシン語 hello.bin に変換します (アセンブラ [ZMA](https://github.com/hra1129/zma) を使用)
```sh
msx_bacon hello.bas hello.asm
zma hello.asm hello.bin
```

[BACONLDR.BIN](msx_basic_compiler/baconloader/BACONLDR.BIN) と共に、MSX上で動かします
```MSX
bload"BACONLDR.BIN",r
bload"hello.bin",r
```

## PLAY (PSG)

MSX-BASIC標準PSGのMML命令と、1～3声の演奏状態を調べる `PLAY(n)` に対応しています。
MMLの解析とBIOS演奏キューへの変換はBACONLIB側で行い、演奏はBIOSの
`STRTMS` を使用します。PLAYを含むプログラムの起動時・`RUN` 時には
`GICINI` でPSGと演奏キューを初期化します。
**更新したコンパイラと、同梱の新しいBACONLDR.BINを組み合わせて使用してください。**
PLAYを含む既存プログラムは、新しいワーク領域に合わせて再コンパイルしてください。

```basic
10 PLAY "CDEFG"
20 A$="T120O4L8CDEFGABO5C"
30 PLAY A$,"T120O3L4CEG","T120O2L2CG"
```

| MML | 対応範囲 |
|---|---|
| `A`～`G` | 音符。直後の `#` / `+` / `-` で半音変更 |
| `C8`、`R8` | 音符・休符だけの音長指定（1～64） |
| `R` | 休符。音長省略時は現在のL設定 |
| `N0`～`N96` | 音番号指定。N0は休符、N1はC1、N96はB8 |
| `O1`～`O8` | オクターブ（初期値4） |
| `L1`～`L64` | 既定の音長（初期値4） |
| `T32`～`T255` | テンポ（初期値120） |
| `V0`～`V15` | 音量（初期値8） |
| `M1`～`M65535` | エンベロープ周期。省略時は255。`M-1` は65535相当 |
| `S0`～`S15` | エンベロープ形状。数値省略時は1。V指定で通常音量へ戻る |
| `X変数$;` | 文字列変数のMMLを展開。入れ子にも対応 |
| `=変数;` | 数値パラメータを変数から取得。例：`T=TP;`、`N=NN;` |
| `.` | 音符・休符の付点。複数付点にも対応 |

小文字・空白も使用できます。O/L/T/V/M/Sの設定はチャンネルごとに次のPLAYへ
引き継ぎます。値なしのO/L/T/Vは初期値へ戻します。
`PLAY ,,"CDEFG"` のようなチャンネルの省略や、空文字列も使用できます。
範囲外の値は `Illegal function call`、未対応のMML命令は `Syntax error` になります。

演奏はバックグラウンドで進みます。ただし、長いMMLではBIOSキューの空きを
待ちながら変換するため、PLAY文から戻るまで待機する場合があります。
元の文字列はPLAYから戻った後に変更・解放して構いません。
各文字列の上限は255バイトです。演奏ワーク領域1152バイトをプログラム内に
確保し、共通の文字列変換バッファと、コンパイラが生成する変数参照表も使用します。
Xマクロの入れ子は24段までで、過剰な再帰は `Out of memory` になります。
変数の型省略はBACONのDEFINT等の規則に従い、整数・単精度・倍精度からの
数値参照に対応します。未使用のスカラ変数はMSX-BASIC同様に0または空文字列です。
確保済み配列への参照も可能です（例：`XA$(1);`、`N=NT(1,2);`）。
配列添字には整数定数・数値変数・括弧と `+` / `-` / `*` を使用できます。
添字内の任意のBASIC関数・実数式には未対応です。範囲外の添字は
`Subscript out of range`、解析中のスタック不足は `Out of memory` になります。

```basic
10 DEFINT A-Z
20 TP=120:A$="O4CDEFG":PLAY "T=TP;M1000S9XA$;"
30 IF PLAY(0) THEN GOTO 30
40 PRINT "FINISHED"
```

`PLAY(0)` はいずれかの声、`PLAY(1)`～`PLAY(3)` は対応する声が演奏中なら
整数の-1、停止中なら0を返します。引数には数値式を使用でき、
0～3以外は `Illegal function call` になります。BIOSの現在の演奏状態を
返すため、キューにある将来の演奏だけを先読みする関数ではありません。

`<` / `>`、`Q` / `@` 等のMSX-MUSIC/MSX-AUDIO/MIDI拡張、
`L8.`、`PLAY #device` は対象外です。
50Hz/60Hzの音長はBIOSの既定割り込み周波数に従います。

OpenMSX用の [test_playディスク](msx_basic_compiler/test_play) も用意しています。
マウントして起動すると基本テストが演奏され、正常時は `PASS PLAY ABI` を表示します。
続けて `BLOAD "PLAYQUE.BIN",R` で長いMMLと3声のキュー試験を実行できます。
`BLOAD "PLAYERR.BIN",R` ではMMLを入力して試せます。例えば `O0` は
`Illegal function call` になることを確認できます。
`BLOAD "PLBOUND.BIN",R` はパラメータの境界値と、演奏中のRUNによる
キュー・既定値の初期化を確認します。正常時は `PASS PLAY BOUNDS` を表示します。
`BLOAD "PLSTD.BIN",R` はPLAY関数、エンベロープ、変数・配列参照、
入れ子のXと長いマクロを確認し、正常時は `PASS STANDARD PLAY` を表示します。
`BLOAD "PLSERR.BIN",R` は入力したケース番号（1～15）に応じた不正入力を試します。
このテストでは実行時エラーになるのが正常です。ケースは
[テストソース](msx_basic_compiler/test_back/test_play_standard_error_runtime.asc) を参照してください。

-------------------------------------------------------------------------------
MSX-BASICとの相違点

## 1. 実行時エラーは最小限
	実行時に検出しないエラーが存在します。 
	エラー処理を省略するが、ある程度高速化に寄与しています。

## 2. DEFINT, DEFSNG, DEFDBL, DEFSTR
	MSX-BASIC では、命令の記述位置で、変数型記述子省略時の型を変更するが、
	BACON では、コンパイル時にソースコード全体から DEFINT, DEFSNG, DEFDBL, DEFSTR
	を検索し、下優先でトータルの「型記述子省略時の型」を求め、それをソース全体に
	適用します。

## 3. VARPTR
	配列変数のアドレスを取得することも可能ですが、配列変数のアドレスは文字列操作後
	に変化する場合があります。
	100 A$="1":B$=A$+"2":DIM B(10):C=VARPTR(B(0)):B$="2"+A$
	このようなコードは、B$ には、A$+"2" を格納するメモリを確保後にそのアドレスを保持
	させますが、2回目の B$="2"+A$ の時に、最初の A$+"2" の結果を格納したメモリを解放
	してガベージコレクションが作動します。
	すると、その間で確保している配列変数 B(10) は、メモリを移動してしまうため、C に
	保存した B(0) のアドレスはズレてしまいます。
	DIM は文字列操作する前に実行しておけば、移動しなくなります。

## 4. ソースコード関連の命令は使用不可能
	LIST, RENUM, TRON, TROFF, MERGE など。

## 5. MacOS

```
$ cd msx_basic_compiler
$ make
$ make install
```

インストール先は /opt/homebrew/bin/msx_bacon になっているので環境に合わせて Makefile を書き換えてください。

-------------------------------------------------------------------------------
### Special thanks to "MSX-BACON のデバッグに協力して頂いた方々"
```
nkt360さん (@nkt360)
IKATENさん (@ikaten_retro)
ちくわ帝国さん (@chikuwa_empire)
b.p.sさん (@BasicProgrammer)
naoさん (@nyaonyao21)
SAILORMAN BRAVO BROSさん（@brapunch2000）
櫻井洋志さん (@h_sakurai)
反動さん (@FF14_hando)
野球帽美緒さん (@baseballcap_mio)
MSX研鑽推進委員会さん (@mdpc___)
福野泰介さん (@taisukef)
```
	※順不同、（）は X（旧Twitter）のアカウント
