#!/bin/bash

# ViOS Binutils Installation Script
# This script helps with manual installation of ViOS binutils

set -e

# Default values
PREFIX="/opt/vios-binutils"
VIOS_PREFIX="/opt/ViOS"
DESTDIR=""
FORCE=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    cat << EOF
ViOS Binutils Installation Script

Usage: $0 [OPTIONS]

Options:
    --prefix=PATH       Installation prefix (default: $PREFIX)
    --vios-prefix=PATH  ViOS libc installation prefix (default: $VIOS_PREFIX)
    --destdir=PATH      Destination directory for staged installs
    --force             Force overwrite existing files
    --help              Show this help message

Examples:
    $0                                    # Install to default locations
    $0 --prefix=/usr/local                # Install to /usr/local
    $0 --destdir=/tmp/pkg --prefix=/usr   # Stage installation for packaging
    $0 --force                            # Force overwrite existing files

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --prefix=*)
            PREFIX="${1#*=}"
            shift
            ;;
        --vios-prefix=*)
            VIOS_PREFIX="${1#*=}"
            shift
            ;;
        --destdir=*)
            DESTDIR="${1#*=}"
            shift
            ;;
        --force)
            FORCE=1
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if we're root for system-wide installations
if [[ "$PREFIX" == "/usr"* ]] || [[ "$PREFIX" == "/opt"* ]] || [[ "$VIOS_PREFIX" == "/usr"* ]] || [[ "$VIOS_PREFIX" == "/opt"* ]]; then
    if [[ $EUID -ne 0 ]] && [[ -z "$DESTDIR" ]]; then
        print_error "Root privileges required for system-wide installation"
        print_info "Try running with sudo or use --destdir for staged installation"
        exit 1
    fi
fi

# Check if source directory exists
if [[ ! -f "Makefile" ]]; then
    print_error "Makefile not found. Please run this script from the ViOS binutils source directory."
    exit 1
fi

print_info "Starting ViOS binutils installation..."
print_info "Installation prefix: $PREFIX"
print_info "ViOS libc prefix: $VIOS_PREFIX"
if [[ -n "$DESTDIR" ]]; then
    print_info "Destination directory: $DESTDIR"
fi

# Check if files already exist
if [[ $FORCE -eq 0 ]] && [[ -z "$DESTDIR" ]]; then
    if [[ -f "$PREFIX/bin/i386-vios-elf-ld" ]]; then
        print_warning "ViOS binutils appear to be already installed"
        print_warning "Use --force to overwrite existing files"
        exit 1
    fi
fi

# Build the project
print_info "Building ViOS binutils..."
if ! make PREFIX="$PREFIX" VIOS_PREFIX="$VIOS_PREFIX"; then
    print_error "Build failed"
    exit 1
fi

# Install the project
print_info "Installing ViOS binutils..."
if ! make install PREFIX="$PREFIX" VIOS_PREFIX="$VIOS_PREFIX" DESTDIR="$DESTDIR"; then
    print_error "Installation failed"
    exit 1
fi

# Verify installation
print_info "Verifying installation..."
INSTALL_PREFIX="$DESTDIR$PREFIX"
if [[ -f "$INSTALL_PREFIX/bin/i386-vios-elf-ld" ]]; then
    print_info "ViOS binutils installed successfully"
else
    print_error "Installation verification failed"
    exit 1
fi

# Check ViOS libc installation
VIOS_INSTALL_PREFIX="$DESTDIR$VIOS_PREFIX"
if [[ -f "$VIOS_INSTALL_PREFIX/lib/libViOSlibc.a" ]]; then
    print_info "ViOS libc installed successfully"
else
    print_warning "ViOS libc installation may have failed"
fi

# Show post-installation information
print_info "Installation complete!"
print_info ""
print_info "To use ViOS binutils, add the following to your shell profile:"
print_info "export PATH=\"$PREFIX/bin:\$PATH\""
print_info "export VIOS_PREFIX=\"$VIOS_PREFIX\""
print_info ""
print_info "Available tools:"
for tool in ld objdump objcopy ar nm strip size strings readelf as; do
    print_info "  i386-vios-elf-$tool"
done
print_info ""
print_info "Linker scripts are available in: $PREFIX/lib/ldscripts/"
print_info "ViOS libc is installed in: $VIOS_PREFIX/"
