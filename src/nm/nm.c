#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PACKAGE_VERSION "1.0.0"

static void usage(const char *prog) {
    printf("Usage: %s [options] file...\n", prog);
    printf("ViOS nm - List symbols from object files\n");
    printf("Options:\n");
    printf("  -a, --all                Display all symbols\n");
    printf("  -g, --extern-only        Display only external symbols\n");
    printf("  -u, --undefined-only     Display only undefined symbols\n");
    printf("  --version                Display version information\n");
    printf("  --help                   Display this help message\n");
}

static void version(void) {
    printf("ViOS nm %s\n", PACKAGE_VERSION);
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
    
    printf("ViOS nm: functionality not yet implemented\n");
    return 0;
}
