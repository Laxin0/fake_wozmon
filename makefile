a.out: test.s
	./vasm -dotdir -Fbin test.s

main: main.c
	gcc main.c fake6502.c -Wall -Wextra -o main
