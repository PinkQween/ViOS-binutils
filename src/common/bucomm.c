/* bucomm.c - Common utility functions for binutils */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>

#include "bucomm.h"

/* Program name */
char *program_name;

/* Set the program name */
void set_program_name(const char *name)
{
    program_name = strdup(name);
}

/* Print error message and exit */
void fatal(const char *format, ...)
{
    va_list args;
    
    fprintf(stderr, "%s: ", program_name);
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    fprintf(stderr, "\n");
    
    exit(1);
}

/* Print warning message */
void warn(const char *format, ...)
{
    va_list args;
    
    fprintf(stderr, "%s: warning: ", program_name);
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    fprintf(stderr, "\n");
}

/* Print error message */
void error(const char *format, ...)
{
    va_list args;
    
    fprintf(stderr, "%s: error: ", program_name);
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    fprintf(stderr, "\n");
}

/* Check if file exists */
int file_exists(const char *filename)
{
    struct stat st;
    return stat(filename, &st) == 0;
}

/* Get file size */
long get_file_size(const char *filename)
{
    struct stat st;
    if (stat(filename, &st) != 0) {
        return -1;
    }
    return st.st_size;
}

/* Read entire file into memory */
char *read_file(const char *filename, size_t *size)
{
    FILE *fp;
    char *buffer;
    long file_size;
    
    fp = fopen(filename, "rb");
    if (!fp) {
        error("cannot open file '%s': %s", filename, strerror(errno));
        return NULL;
    }
    
    fseek(fp, 0, SEEK_END);
    file_size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    
    buffer = malloc(file_size + 1);
    if (!buffer) {
        error("out of memory");
        fclose(fp);
        return NULL;
    }
    
    if (fread(buffer, 1, file_size, fp) != (size_t)file_size) {
        error("cannot read file '%s': %s", filename, strerror(errno));
        free(buffer);
        fclose(fp);
        return NULL;
    }
    
    buffer[file_size] = '\0';
    fclose(fp);
    
    if (size) {
        *size = file_size;
    }
    
    return buffer;
}

/* Write data to file */
int write_file(const char *filename, const void *data, size_t size)
{
    FILE *fp;
    
    fp = fopen(filename, "wb");
    if (!fp) {
        error("cannot create file '%s': %s", filename, strerror(errno));
        return -1;
    }
    
    if (fwrite(data, 1, size, fp) != size) {
        error("cannot write file '%s': %s", filename, strerror(errno));
        fclose(fp);
        return -1;
    }
    
    fclose(fp);
    return 0;
}

/* Create directory if it doesn't exist */
int make_directory(const char *path)
{
    struct stat st;
    
    if (stat(path, &st) == 0) {
        return S_ISDIR(st.st_mode) ? 0 : -1;
    }
    
    if (mkdir(path, 0755) != 0) {
        error("cannot create directory '%s': %s", path, strerror(errno));
        return -1;
    }
    
    return 0;
}
