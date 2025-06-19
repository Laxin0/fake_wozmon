ASM=vasm6502_oldstyle
ASMFLAGS=-dotdir -Fbin

CC=gcc
CFLAGS=-Wall -Wextra

SRC=src
BUILD=build

.PHONY:
all: wozmon.bin main prog.bin

wozmon.bin: wozmon.s
	./$(ASM) $(SRC)/wozmon.s $(ASMFLAGS) -o $(BUILD)/wozmon.bin

main: main.c
	$(CC) $(SRC)/main.c thirdparty/fake6502.c $(CFLAGS) -o $(BUILD)/main

prog.bin: bf.s
	./$(ASM) $(SRC)/bf.s $(ASMFLAGS) -o $(BUILD)/prog.bin

