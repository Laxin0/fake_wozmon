#include <stdio.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>

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

int main() {
    char ch;
    set_nonblocking_input();

    printf("Press keys (press 'q' to quit):\n");
    printf("EOF = %x\n", EOF);
    while (1) {
        ch = getchar();
        if (ch != EOF) {
            printf("You pressed: %x\n", ch);
            if (ch == 'q') break;
        }
        usleep(10000); // small sleep to reduce CPU usage
    }

    reset_input_mode();
    return 0;
}
