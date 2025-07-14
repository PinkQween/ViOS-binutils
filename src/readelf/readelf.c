#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PACKAGE_VERSION "1.0.0"

static void usage(const char *prog) {
    printf("Usage: %s [options] file...\n", prog);
    printf("ViOS readelf - Display information about ELF files\n");
    printf("Options:\n");
    printf("  -a, --all                Display all information\n");
    printf("  -h, --file-header        Display ELF file header\n");
    printf("  -l, --program-headers    Display program headers\n");
    printf("  -S, --section-headers    Display section headers\n");
    printf("  -s, --syms               Display symbol table\n");
    printf("  --version                Display version information\n");
    printf("  --help                   Display this help message\n");
}

static void version(void) {
    printf("ViOS readelf %s\n", PACKAGE_VERSION);
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
    
    printf("ViOS readelf: functionality not yet implemented\n");
    return 0;
}
