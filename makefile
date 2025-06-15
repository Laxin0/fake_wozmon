
.PHONY:
wozmon: a.out

a.out: test.s
	./vasm -dotdir -Fbin my_wozmon.s

main: main.c
	gcc main.c fake6502.c -Wall -Wextra -o main
