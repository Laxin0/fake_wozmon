#!/usr/bin/bash

ASM=vasm6502_oldstyle
ASMFLAGS="-dotdir -Fbin -esc"

CC=gcc
CFLAGS="-Wall -Wextra"

$CC src/main.c thirdparty/fake6502.c $CFLAGS -o build/main
./src/regdef.sh > src/reg.s
./$ASM src/wozmon.s $ASMFLAGS -o build/wozmon.bin
./$ASM src/std.s $ASMFLAGS -o build/std.bin

if [ "$1" = "-r" ]; then
    ./build/main ./build/wozmon.bin
fi
