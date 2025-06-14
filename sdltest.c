#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdbool.h>

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Window *win = SDL_CreateWindow("Hello SDL2",
                                       SDL_WINDOWPOS_CENTERED,
                                       SDL_WINDOWPOS_CENTERED,
                                       640, 480,
                                       SDL_WINDOW_SHOWN);

    if (win == NULL) {
        printf("SDL_CreateWindow Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    SDL_Event event;
    bool run = true;
    while (run){
        while (SDL_PollEvent(&event)){
            if (event.type == SDL_KEYDOWN){
                printf("%d\n", event.key.keysym.sym);
                if (event.key.keysym.sym == SDLK_q){
                    run = false;
                    break;
                }
            }
        }
    }
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}
