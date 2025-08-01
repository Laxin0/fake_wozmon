#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>
#include <stdlib.h>

// 01FF - 0100 Stack
#define KBD     0xD010 
#define KBDCR   0xD011 
#define DSP     0xD012 
#define DSPCR   0xD013
#define FSTDIN  0xD000
#define FSTDOUT 0xD001
#define FHEXOUT 0xD002
#define FSYS    0xD003

void set_nonblocking_input() {
    struct termios t;
    tcgetattr(STDIN_FILENO, &t);
    t.c_lflag &= ~(ICANON | ECHO); // disable canonical mode and echo
    tcsetattr(STDIN_FILENO, TCSANOW, &t);

    // Set stdin to non-blocking
    fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
}

void reset_input_mode() {
    struct termios t;
    tcgetattr(STDIN_FILENO, &t);
    t.c_lflag |= (ICANON | ECHO); // enable canonical mode and echo
    tcsetattr(STDIN_FILENO, TCSANOW, &t);
}

extern void reset6502();
extern void step6502();

static uint8_t memory[1<<16] = {0};

uint8_t read6502(uint16_t address){
    //printf("Read\t %4x from\t %4x\n", memory[address], address);
    char ch;
    switch(address){
        case KBDCR:
            ch = getchar();
            if (ch != EOF){
                ch |= 0x80;
                memory[KBD] = ch;
                return ch;
            }
            return 0;
        case DSPCR:
            return 0;
        case FSTDIN:
            ch = getchar();
            return ch == EOF ? 0b10000000 : ch;
    }
    return memory[address];
}

void write6502(uint16_t address, uint8_t value){
    //printf("Write\t %4x to\t %4x\n", value, address);
    switch (address){
        case DSP:
        case FSTDOUT:
            putchar(value & 0b01111111);
            break;
        case FHEXOUT:
            printf("%X ", value);
            break;
        case FSYS:
            printf("Exited by writing into SYS\n");
            reset_input_mode();
            exit(0);
    }
    memory[address] = value;
}

void load_memory(char *file_name){
   FILE *fptr;
   fptr = fopen(file_name, "rb");
   fread(memory, sizeof(memory), 1, fptr);
}

void save_memory(char *file_name){
    FILE *fptr;
    fptr = fopen(file_name, "wb");
    fwrite(memory, sizeof(memory), 1, fptr);
}

int main(int argc, char *argv[]){

    if (argc < 2) {
        printf("No input file was provided!\n");
        return 1;
    }

    char *input_file = argv[1];

    set_nonblocking_input();
    
    load_memory(input_file);

    reset6502();
    
    for(;;){
        step6502();
        usleep(100);
        //char ch = getchar();
        //switch (ch){
        //    case 's': save_memory("build/dump.bin"); break;
        //    case 'q': goto finish;
        //}
        //ungetc(ch, stdin);
    }

finish:
    reset_input_mode();
    return 0;
}
