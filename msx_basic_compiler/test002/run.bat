..\x64\release\msx_bacon.exe -zma test.asc test.asm
rem ..\x64\release\msx_bacon.exe -m80 test.asc test.mac
..\zma.exe test.asm test.bin
copy ..\baconloader\BACONLDR.BIN .
pause
