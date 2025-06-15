#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>

// 01FF - 0100 Stack
#define KBD   0xD010 
#define KBDCR 0xD011 
#define DSP   0xD012 
#define DSPCR 0xD013 

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
    if (address == KBDCR){
        char ch = getchar();
        if (ch != EOF){
            ch |= 0x80;
            memory[KBD] = ch;
            return ch;
        }
        return 0;
    }else if (address == DSPCR){
        return 0;
    }
    return memory[address];
}

void write6502(uint16_t address, uint8_t value){
    //printf("Write\t %4x to\t %4x\n", value, address);
    if (address == DSP){
        putchar(value & 0b01111111);
    }
    memory[address] = value;
}

void load_prog(){
    FILE *fptr;
    fptr = fopen("prog.bin", "rb");
    fread(memory + 0x1200, 100, 1, fptr);
}

void read_file(){
   FILE *fptr;
   fptr = fopen("a.out", "rb");
   fread(memory, sizeof(memory), 1, fptr);
}

void save_file(){
    FILE *fptr;
    fptr = fopen("a.out", "wb");
    fwrite(memory, sizeof(memory), 1, fptr);
}

int main(){
    set_nonblocking_input();
    read_file();
    load_prog();

    reset6502();
    for(;;){
        step6502();
        usleep(100);
        char ch = getchar();
        if (ch == 'q'){
            save_file();
        }
        ungetc(ch, stdin);
    }
    reset_input_mode();
    return 0;
}
