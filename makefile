ASM=vasm6502_oldstyle
ASMFLAGS=-dotdir -Fbin

CC=gcc
CFLAGS=-Wall -Wextra

.PHONY:
all: wozmon.bin main prog.bin

wozmon.bin: src/wozmon.s
	./$(ASM) src/wozmon.s $(ASMFLAGS) -o build/wozmon.bin

main: src/main.c
	$(CC) src/main.c thirdparty/fake6502.c $(CFLAGS) -o build/main

prog.bin: src/bf.s
	./$(ASM) src/bf.s $(ASMFLAGS) -o build/prog.bin

