..\x64\release\msx_bacon.exe -zma -msx2 test.asc test.asm
rem ..\x64\release\msx_bacon.exe -m80 -msx2 test.asc test.mac
..\zma.exe test.asm test.bin
copy ..\baconloader\BACONLDR.BIN .
pause
