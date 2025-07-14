# ViOS Binutils

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](https://github.com/skairipa/vios-binutils)
[![Target](https://img.shields.io/badge/target-i386--vios--elf-blue)](https://github.com/skairipa/vios-binutils)

A collection of binary utilities specifically designed for the ViOS operating system, targeting the i386 architecture with ELF format.

## Overview

ViOS Binutils provides essential development tools for building applications for the ViOS operating system:

- **i386-vios-elf-ld**: Linker with ViOS-specific defaults and memory layout
- **i386-vios-elf-objcopy**: Object file format converter
- **i386-vios-elf-objdump**: Object file disassembler and analyzer
- **i386-vios-elf-ar**: Archive manager for static libraries
- **i386-vios-elf-strip**: Symbol stripper for reducing binary size
- **i386-vios-elf-nm**: Symbol table viewer
- **i386-vios-elf-size**: Section size reporter
- **i386-vios-elf-readelf**: ELF file analyzer
- **i386-vios-elf-strings**: String extractor from binaries
- **i386-vios-elf-as**: Assembler wrapper

## Features

✨ **Key Features:**
- Pre-configured for i386-vios-elf target architecture
- Default linker scripts optimized for ViOS userspace (0x400000 base)
- Integration with ViOS libc and system calls
- Standard ELF32 i386 output format
- GNU-style command-line interface compatibility
- Cross-platform support (macOS, Linux)

## Installation

### Homebrew (Recommended)

```bash
# Add the ViOS tap
brew tap skairipa/vios

# Install ViOS binutils
brew install vios-binutils
```

### From Source

#### Prerequisites

- GCC or Clang compiler
- Make
- zlib development headers

#### Build Steps

```bash
# Clone the repository
git clone https://github.com/skairipa/vios-binutils.git
cd vios-binutils

# Configure the build
./configure --prefix=/opt/vios-binutils

# Build
make

# Install
sudo make install
```

#### Custom Installation

```bash
# Custom prefix
./configure --prefix=/usr/local

# Enable shared libraries
./configure --enable-shared

# Cross-compile for different host
./configure --host=x86_64-linux-gnu
```

## Usage

### Basic Compilation

```bash
# Compile a C source file
i386-vios-elf-gcc -c main.c -o main.o

# Link with ViOS defaults
i386-vios-elf-ld main.o -o main.elf

# Or use the full toolchain
i386-vios-elf-gcc main.c -o main.elf
```

### Working with Archives

```bash
# Create a static library
i386-vios-elf-ar rcs libmylib.a obj1.o obj2.o obj3.o

# List archive contents
i386-vios-elf-ar t libmylib.a

# Extract objects from archive
i386-vios-elf-ar x libmylib.a
```

### Binary Analysis

```bash
# Disassemble binary
i386-vios-elf-objdump -d main.elf

# Show ELF header information
i386-vios-elf-readelf -h main.elf

# Display section sizes
i386-vios-elf-size main.elf

# List symbols
i386-vios-elf-nm main.elf

# Extract strings
i386-vios-elf-strings main.elf
```

### Binary Manipulation

```bash
# Strip debugging symbols
i386-vios-elf-strip main.elf

# Convert ELF to binary
i386-vios-elf-objcopy -O binary main.elf main.bin

# Extract specific sections
i386-vios-elf-objcopy -j .text -O binary main.elf text.bin
```

## Memory Layout

The default linker script for ViOS applications uses the following memory layout:

```
0x400000    .text       (Code section, page-aligned)
            .asm        (Assembly section, page-aligned)
            .rodata     (Read-only data, page-aligned)
            .data       (Initialized data, page-aligned)
            .bss        (Uninitialized data, page-aligned)
```

All sections are aligned to 4096-byte boundaries for optimal memory management in ViOS.

## Integration with ViOS

ViOS Binutils is designed to work seamlessly with:

- **ViOS Kernel**: Proper ELF loading and execution
- **ViOS libc**: Standard C library for ViOS
- **ViOS System Calls**: Native system call interface
- **ViOS File System**: Compatible with ViOS executable format

## Configuration Options

The configure script supports various options:

| Option | Description | Default |
|--------|-------------|---------|
| `--prefix=DIR` | Installation directory | `/opt/vios-binutils` |
| `--target=TARGET` | Target triplet | `i386-vios-elf` |
| `--host=HOST` | Host system | Auto-detected |
| `--enable-shared` | Build shared libraries | No |
| `--enable-static` | Build static libraries | Yes |

## Development

### Building from Git

```bash
git clone https://github.com/skairipa/vios-binutils.git
cd vios-binutils
./configure
make
make check  # Run tests (if available)
```

### Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Compatibility

### Host Platforms
- macOS (Intel/Apple Silicon)
- Linux (x86_64)
- Other Unix-like systems

### Target Platform
- i386-vios-elf (ViOS operating system)

## Troubleshooting

### Common Issues

**Q: Command not found after installation**
```bash
# Add to your PATH
export PATH="/opt/vios-binutils/bin:$PATH"
```

**Q: Missing zlib during build**
```bash
# macOS
brew install zlib

# Ubuntu/Debian
sudo apt-get install zlib1g-dev

# CentOS/RHEL
sudo yum install zlib-devel
```

**Q: Permission denied during installation**
```bash
# Use sudo for system-wide installation
sudo make install

# Or install to user directory
./configure --prefix="$HOME/.local"
```

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/skairipa/vios-binutils/tags).

## Authors

- **ViOS Development Team** - *Initial work* - [ViOS Project](https://github.com/skairipa/ViOS)

See also the list of [contributors](https://github.com/skairipa/vios-binutils/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- GNU Binutils project for inspiration and compatibility
- ViOS operating system project
- The open-source community

## Related Projects

- [ViOS](https://github.com/skairipa/ViOS) - The ViOS operating system
- [ViOS libc](https://github.com/skairipa/ViOS-libc) - Standard C library for ViOS
- [GNU Binutils](https://www.gnu.org/software/binutils/) - Original binutils project

## Support

- 📖 [Documentation](README.md)
- 🐛 [Report a Bug](https://github.com/skairipa/vios-binutils/issues/new?template=bug_report.md)
- 💡 [Request a Feature](https://github.com/skairipa/vios-binutils/issues/new?template=feature_request.md)
- 💬 [Discussions](https://github.com/skairipa/vios-binutils/discussions)

