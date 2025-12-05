#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Disable buffering
void setup() {
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);
}

// Secret function that prints the flag
void win() {
    char flag[128];
    FILE *f = fopen("flag.txt", "r");
    if (f == NULL) {
        puts("Flag file not found! Contact admin.");
        exit(1);
    }
    fgets(flag, sizeof(flag), f);
    fclose(f);
    printf("🍋 Congratulations! Here's your flag: %s\n", flag);
    exit(0);
}

// Vulnerable function with buffer overflow
void vuln() {
    char buffer[64];
    
    printf("🍋 Welcome to L3m0n's PWN Challenge! 🍋\n");
    printf("=======================================\n\n");
    printf("Can you exploit this buffer overflow?\n");
    printf("Hint: The win() function is at %p\n\n", (void*)win);
    printf("Enter your input: ");
    
    // Vulnerable gets() - classic buffer overflow
    gets(buffer);
    
    printf("\nYou entered: %s\n", buffer);
    printf("Nice try, but that's not enough!\n");
}

int main() {
    setup();
    vuln();
    return 0;
}
