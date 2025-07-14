/* bucomm.h - Common utility functions for binutils */

#ifndef BUCOMM_H
#define BUCOMM_H

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>

/* Program name */
extern char *program_name;

/* Function prototypes */
void set_program_name(const char *name);
void fatal(const char *format, ...) __attribute__((noreturn));
void warn(const char *format, ...);
void error(const char *format, ...);

int file_exists(const char *filename);
long get_file_size(const char *filename);
char *read_file(const char *filename, size_t *size);
int write_file(const char *filename, const void *data, size_t size);
int make_directory(const char *path);

/* Version information */
#define PACKAGE_VERSION "1.0.0"
#define PACKAGE_STRING "vios-binutils 1.0.0"

#endif /* BUCOMM_H */
