ASM := arm_vasm

.PHONY:
all: wozmon.bin main prog.bin

wozmon.bin: wozmon.s
	./$(ASM) -dotdir -Fbin wozmon.s -o wozmon.bin

main: main.c
	gcc main.c fake6502.c -Wall -Wextra -o main

prog.bin: bf.s
	./$(ASM) -dotdir -Fbin bf.s -o prog.bin

