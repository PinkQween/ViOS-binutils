# Installation Instructions

This document provides instructions for installing ViOS binutils with integrated ViOS libc on different operating systems.

## Package Managers

### Homebrew (macOS/Linux)

```bash
# Add the ViOS tap (if you have a custom tap)
brew tap PinkQween/vios

# Install ViOS binutils
brew install vios-binutils

# Or install directly from this repository
brew install --HEAD https://github.com/PinkQween/ViOS-binutils/raw/main/Formula/vios-binutils.rb
```

### APT (Debian/Ubuntu)

#### From Release Packages

1. Download the latest `.deb` package from the [releases page](https://github.com/PinkQween/ViOS-binutils/releases)
2. Install using dpkg:

```bash
sudo dpkg -i vios-binutils_*.deb
sudo apt-get install -f  # Fix any dependency issues
```

#### Building from Source

```bash
# Install build dependencies
sudo apt-get update
sudo apt-get install -y build-essential debhelper devscripts fakeroot zlib1g-dev curl

# Clone the repository
git clone https://github.com/PinkQween/ViOS-binutils.git
cd ViOS-binutils

# Build the package
dpkg-buildpackage -us -uc -b

# Install the package
sudo dpkg -i ../vios-binutils_*.deb
```

### Pacman (Arch Linux)

#### From Release Packages

1. Download the latest `.pkg.tar.xz` package from the [releases page](https://github.com/PinkQween/ViOS-binutils/releases)
2. Install using pacman:

```bash
sudo pacman -U vios-binutils-*.pkg.tar.xz
```

#### Building from Source

```bash
# Install build dependencies
sudo pacman -S base-devel git curl zlib

# Clone the repository
git clone https://github.com/PinkQween/ViOS-binutils.git
cd ViOS-binutils

# Build the package
makepkg

# Install the package
sudo pacman -U vios-binutils-*.pkg.tar.xz
```

#### Using AUR (if published)

```bash
# Using yay
yay -S vios-binutils

# Using paru
paru -S vios-binutils
```

## Manual Installation

### From Source

#### Using the Installation Script (Recommended)

```bash
# Install dependencies
# On Debian/Ubuntu:
sudo apt-get install -y build-essential zlib1g-dev curl

# On Arch Linux:
sudo pacman -S base-devel zlib curl

# On macOS:
brew install zlib curl

# Clone and install
git clone https://github.com/PinkQween/ViOS-binutils.git
cd ViOS-binutils

# Install to default location (/opt/vios-binutils)
sudo ./install.sh

# Or install to custom location
sudo ./install.sh --prefix=/usr/local --vios-prefix=/usr/local/vios
```

#### Manual Installation

```bash
# Clone and build
git clone https://github.com/PinkQween/ViOS-binutils.git
cd ViOS-binutils
make
sudo make install
```

### Custom Installation Paths

```bash
# Install to custom prefix
make install PREFIX=/usr/local VIOS_PREFIX=/usr/local/vios

# Install to temporary directory (for packaging)
make install DESTDIR=/tmp/install PREFIX=/usr VIOS_PREFIX=/opt/ViOS
```

## Verification and Testing

### Quick Verification

After installation, verify that the tools are working:

```bash
# Check that binaries are installed
which i386-vios-elf-ld
which i386-vios-elf-gcc  # If you have a cross-compiler

# Check versions
i386-vios-elf-ld --version
i386-vios-elf-objdump --version

# Check ViOS libc installation
ls -la /opt/ViOS/lib/libViOSlibc.a
ls -la /opt/ViOS/include/

# Test basic functionality
echo 'int main() { return 0; }' > test.c
i386-vios-elf-gcc -c test.c -o test.o  # If you have a cross-compiler
i386-vios-elf-ld test.o -o test
i386-vios-elf-objdump -h test
```

### Comprehensive Testing

For comprehensive testing of the built binaries:

```bash
# Run the test suite (from source directory)
cd ViOS-binutils
./test.sh
```

This will test:
- Binary existence and executability
- Basic functionality (help commands)
- Object file creation and linking (if nasm is available)
- ViOS libc installation
- Linker scripts

## Environment Setup

Add the following to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# Add ViOS binutils to PATH
export PATH="/opt/vios-binutils/bin:$PATH"

# Set ViOS development environment
export VIOS_PREFIX="/opt/ViOS"
export VIOS_SYSROOT="$VIOS_PREFIX"
export VIOS_INCLUDE="$VIOS_PREFIX/include"
export VIOS_LIB="$VIOS_PREFIX/lib"
```

## Troubleshooting

### Common Issues

1. **Permission denied during installation**
   - Make sure you're running installation commands with `sudo`
   - Check file permissions on the installation directories

2. **ViOS libc not found**
   - The build system automatically downloads and installs ViOS libc
   - Check your internet connection
   - Verify curl is installed

3. **Missing dependencies**
   - Install build dependencies for your distribution
   - Check that zlib development headers are installed

4. **Build failures**
   - Ensure you have a working C compiler
   - Check that all required build tools are installed
   - Review the error messages for specific missing components

### Getting Help

- Check the [GitHub issues](https://github.com/PinkQween/ViOS-binutils/issues)
- Review the build logs for detailed error messages
- Ensure your system meets the requirements listed in the README

## Development

For development and testing:

```bash
# Build in development mode
make clean
make

# Run tests (if implemented)
make test

# Install to temporary location for testing
make install DESTDIR=/tmp/test PREFIX=/usr VIOS_PREFIX=/opt/ViOS
```
