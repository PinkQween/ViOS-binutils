/* version.c - Version information for ViOS binutils */

#include <stdio.h>
#include "bucomm.h"

void print_version(const char *progname)
{
    printf("%s (%s) %s\n", progname, PACKAGE_STRING, PACKAGE_VERSION);
    printf("Copyright (C) 2025 ViOS Development Team\n");
    printf("This program is free software; you may redistribute it under the terms of\n");
    printf("the MIT License. This program has absolutely no warranty.\n");
}
