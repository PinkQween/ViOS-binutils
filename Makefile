PREFIX        := /opt/vios-binutils
TARGET        := i386-vios-elf
CC            := gcc
AR            := ar
STRIP         := strip
INSTALL       := install

# ViOS libc integration
VIOS_LIBC_URL := https://github.com/PinkQween/ViOS-Libc/releases/download/Release/ViOS-Libc.tar.gz
VIOS_LIBC_DIR := ViOS-Libc
VIOS_PREFIX   := /opt/ViOS

CFLAGS        := -O2 -g -Wall -Wextra -std=c99 -D_GNU_SOURCE \
                 -DTARGET_I386=1 -DTARGET_ELF=1 \
                 -DPACKAGE_VERSION='"1.0.0"' \
                 -DBINDIR='"$(PREFIX)/bin"' \
                 -DLIBDIR='"$(PREFIX)/lib"' \
                 -DDATADIR='"$(PREFIX)/share"' \
                 -Iinclude -Isrc

LDFLAGS       := 
LIBS          := 

# Source files - only use what exists
COMMON_SRC    := src/common/bucomm.c src/common/version.c src/common/filemode.c

# For now, create minimal stub implementations
LD_SRC        := $(wildcard src/ld/*.c)
OBJDUMP_SRC   := $(wildcard src/objdump/*.c)
OBJCOPY_SRC   := $(wildcard src/objcopy/*.c)
AR_SRC        := $(wildcard src/ar/*.c)
NM_SRC        := $(wildcard src/nm/*.c)
STRIP_SRC     := $(wildcard src/strip/*.c)
SIZE_SRC      := $(wildcard src/size/*.c)
STRINGS_SRC   := $(wildcard src/strings/*.c)
READELF_SRC   := $(wildcard src/readelf/*.c)
AS_SRC        := $(wildcard src/as/*.c)

# Object files
COMMON_OBJ    := $(patsubst src/%.c,build/%.o,$(COMMON_SRC))
LD_OBJ        := $(patsubst src/%.c,build/%.o,$(LD_SRC))
OBJDUMP_OBJ   := $(patsubst src/%.c,build/%.o,$(OBJDUMP_SRC))
OBJCOPY_OBJ   := $(patsubst src/%.c,build/%.o,$(OBJCOPY_SRC))
AR_OBJ        := $(patsubst src/%.c,build/%.o,$(AR_SRC))
NM_OBJ        := $(patsubst src/%.c,build/%.o,$(NM_SRC))
STRIP_OBJ     := $(patsubst src/%.c,build/%.o,$(STRIP_SRC))
SIZE_OBJ      := $(patsubst src/%.c,build/%.o,$(SIZE_SRC))
STRINGS_OBJ   := $(patsubst src/%.c,build/%.o,$(STRINGS_SRC))
READELF_OBJ   := $(patsubst src/%.c,build/%.o,$(READELF_SRC))
AS_OBJ        := $(patsubst src/%.c,build/%.o,$(AS_SRC))

# Binary targets
PROGRAMS      := $(TARGET)-ld $(TARGET)-objdump $(TARGET)-objcopy \
                 $(TARGET)-ar $(TARGET)-nm $(TARGET)-strip \
                 $(TARGET)-size $(TARGET)-strings $(TARGET)-readelf \
                 $(TARGET)-as

.PHONY: all clean install uninstall vios-libc ldscripts check

all: vios-libc ldscripts $(PROGRAMS)

# Install ViOS libc first
vios-libc:
	@echo "Checking for ViOS libc..."
	@if [ ! -f "$(VIOS_PREFIX)/lib/libViOSlibc.a" ]; then \
		echo "ViOS libc not found. Installing..."; \
		if [ ! -f "ViOS-Libc.tar.gz" ]; then \
			echo "Downloading ViOS libc..."; \
			curl -L $(VIOS_LIBC_URL) -o ViOS-Libc.tar.gz; \
		fi; \
		if [ ! -d "$(VIOS_LIBC_DIR)" ]; then \
			tar -xzf ViOS-Libc.tar.gz; \
		fi; \
		if [ -w "$(dir $(VIOS_PREFIX))" ] || [ ! -d "$(dir $(VIOS_PREFIX))" ]; then \
			mkdir -p $(VIOS_PREFIX)/include $(VIOS_PREFIX)/lib; \
			cp -r $(VIOS_LIBC_DIR)/include/* $(VIOS_PREFIX)/include/; \
			cp -r $(VIOS_LIBC_DIR)/lib/* $(VIOS_PREFIX)/lib/; \
		else \
			sudo mkdir -p $(VIOS_PREFIX)/include $(VIOS_PREFIX)/lib; \
			sudo cp -r $(VIOS_LIBC_DIR)/include/* $(VIOS_PREFIX)/include/; \
			sudo cp -r $(VIOS_LIBC_DIR)/lib/* $(VIOS_PREFIX)/lib/; \
		fi; \
		echo "ViOS libc installed to $(VIOS_PREFIX)"; \
	else \
		echo "ViOS libc already installed"; \
	fi

# Create linker scripts
ldscripts:
	@mkdir -p ldscripts
	@echo 'ENTRY(_start)' > ldscripts/vios.ld
	@echo 'OUTPUT_FORMAT(elf32-i386)' >> ldscripts/vios.ld
	@echo 'OUTPUT_ARCH(i386)' >> ldscripts/vios.ld
	@echo '' >> ldscripts/vios.ld
	@echo 'SECTIONS' >> ldscripts/vios.ld
	@echo '{' >> ldscripts/vios.ld
	@echo '    . = 0x400000;' >> ldscripts/vios.ld
	@echo '    .text : ALIGN(4096) { *(.text) *(.text.*) }' >> ldscripts/vios.ld
	@echo '    .asm : ALIGN(4096) { *(.asm) }' >> ldscripts/vios.ld
	@echo '    .rodata : ALIGN(4096) { *(.rodata) *(.rodata.*) }' >> ldscripts/vios.ld
	@echo '    .data : ALIGN(4096) { *(.data) *(.data.*) }' >> ldscripts/vios.ld
	@echo '    .bss : ALIGN(4096) { *(COMMON) *(.bss) *(.bss.*) }' >> ldscripts/vios.ld
	@echo '    /DISCARD/ : { *(.comment) *(.note.*) }' >> ldscripts/vios.ld
	@echo '}' >> ldscripts/vios.ld

# Build binaries - only build if source files exist
$(TARGET)-ld: $(LD_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(LD_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-objdump: $(OBJDUMP_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(OBJDUMP_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-objcopy: $(OBJCOPY_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(OBJCOPY_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-ar: $(AR_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(AR_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-nm: $(NM_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(NM_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-strip: $(STRIP_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(STRIP_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-size: $(SIZE_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(SIZE_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-strings: $(STRINGS_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(STRINGS_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-readelf: $(READELF_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(READELF_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

$(TARGET)-as: $(AS_OBJ) $(COMMON_OBJ) | build
	@if [ -n "$(AS_SRC)" ]; then \
		echo "  LD    $@"; \
		$(CC) $(LDFLAGS) -o $@ $^ $(LIBS); \
	else \
		echo "  SKIP  $@ (no source files)"; \
	fi

# Compile C files
build/%.o: src/%.c | build
	@mkdir -p $(dir $@)
	@echo "  CC    $@"
	@$(CC) $(CFLAGS) -c $< -o $@

# Create build directory
build:
	@mkdir -p build/common build/ld build/objdump build/objcopy build/ar build/nm build/strip build/size build/strings build/readelf build/as

# Installation
install: all
	@echo "Installing ViOS binutils to $(PREFIX)..."
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/lib/ldscripts
	@mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	@mkdir -p $(DESTDIR)$(PREFIX)/share/doc/vios-binutils
	
	# Install binaries
	@for prog in $(PROGRAMS); do \
		echo "  Installing $$prog"; \
		$(INSTALL) -m 755 $$prog $(DESTDIR)$(PREFIX)/bin/; \
	done
	
	# Install linker scripts
	@$(INSTALL) -m 644 ldscripts/*.ld $(DESTDIR)$(PREFIX)/lib/ldscripts/
	
	# Install documentation
	@$(INSTALL) -m 644 README.md $(DESTDIR)$(PREFIX)/share/doc/vios-binutils/
	@$(INSTALL) -m 644 ChangeLog $(DESTDIR)$(PREFIX)/share/doc/vios-binutils/
	
	@echo "Installation complete"

uninstall:
	@echo "Uninstalling ViOS binutils..."
	@rm -f $(DESTDIR)$(PREFIX)/bin/$(TARGET)-*
	@rm -rf $(DESTDIR)$(PREFIX)/lib/ldscripts
	@rm -rf $(DESTDIR)$(PREFIX)/share/doc/vios-binutils
	@echo "Uninstallation complete"

# Basic test/check target
check: all
	@echo "Running basic tests..."
	@for prog in $(PROGRAMS); do \
		echo "Testing $$prog..."; \
		./$$prog --version >/dev/null 2>&1 && echo "  $$prog: OK" || echo "  $$prog: FAIL"; \
	done
	@echo "Basic tests complete"

clean:
	@echo "Cleaning..."
	@rm -rf build $(PROGRAMS) ldscripts $(VIOS_LIBC_DIR) ViOS-Libc.tar.gz
	@echo "Clean complete"

# Show help
help:
	@echo "ViOS Binutils Build System"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Build all binutils (default)"
	@echo "  install  - Install binutils to $(PREFIX)"
	@echo "  clean    - Clean build files"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX   - Installation prefix (default: $(PREFIX))"
	@echo "  DESTDIR  - Destination directory for staged installs"
