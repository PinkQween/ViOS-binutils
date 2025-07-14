#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PACKAGE_VERSION "1.0.0"

static void usage(const char *prog) {
    printf("Usage: %s [options] file...\n", prog);
    printf("ViOS as - Assembler\n");
    printf("Options:\n");
    printf("  -o FILE                  Set output file name\n");
    printf("  -32                      Generate 32-bit code\n");
    printf("  -64                      Generate 64-bit code\n");
    printf("  --version                Display version information\n");
    printf("  --help                   Display this help message\n");
}

static void version(void) {
    printf("ViOS as %s\n", PACKAGE_VERSION);
    printf("Copyright (C) 2024 ViOS Project\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        usage(argv[0]);
        return 1;
    }
    
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--version") == 0) {
            version();
            return 0;
        }
    }
    
    printf("ViOS as: functionality not yet implemented\n");
    return 0;
}
