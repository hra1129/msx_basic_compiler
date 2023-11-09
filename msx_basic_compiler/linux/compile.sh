#!/bin/sh

if test -e "*.o"; then
	rm *.o
fi
echo "assembler"
g++ -O2 -std=c++17 -W -c -I.. -I../assembler -I../collections -I../expressions ../assembler/*.cpp
echo "collections"
g++ -O2 -std=c++17 -W -c -I.. -I../assembler -I../collections -I../expressions ../collections/*.cpp
echo "expressions"
g++ -O2 -std=c++17 -W -c -I.. -I../assembler -I../collections -I../expressions ../expressions/*.cpp
echo "top"
g++ -O2 -std=c++17 -W -c -I.. -I../assembler -I../collections -I../expressions ../*.cpp
echo "link"
g++ -O2 *.o -o msx_bacon
