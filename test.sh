#!/bin/bash

# ViOS Binutils Test Script
# This script tests the built ViOS binutils

set -e

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

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Test variables
FAILED_TESTS=0
PASSED_TESTS=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    print_info "Running test: $test_name"
    
    if eval "$test_command"; then
        print_success "✓ $test_name"
        ((PASSED_TESTS++))
    else
        print_error "✗ $test_name"
        ((FAILED_TESTS++))
    fi
    echo
}

print_info "Starting ViOS binutils tests..."
echo

# Test 1: Check if all binaries exist
print_info "Testing binary existence..."
for tool in ld objdump objcopy ar nm strip size strings readelf as; do
    run_test "Binary exists: i386-vios-elf-$tool" "test -f i386-vios-elf-$tool"
done

# Test 2: Check if binaries are executable
print_info "Testing binary executability..."
for tool in ld objdump objcopy ar nm strip size strings readelf as; do
    run_test "Binary executable: i386-vios-elf-$tool" "test -x i386-vios-elf-$tool"
done

# Test 3: Check if linker scripts exist
print_info "Testing linker scripts..."
run_test "Linker script directory exists" "test -d ldscripts"
run_test "ViOS linker script exists" "test -f ldscripts/vios.ld"

# Test 4: Test basic functionality (if possible)
print_info "Testing basic functionality..."

# Test linker help
run_test "Linker help" "./i386-vios-elf-ld --help >/dev/null 2>&1"

# Test objdump help
run_test "Objdump help" "./i386-vios-elf-objdump --help >/dev/null 2>&1"

# Test ar help
run_test "Ar help" "./i386-vios-elf-ar --help >/dev/null 2>&1"

# Test nm help
run_test "Nm help" "./i386-vios-elf-nm --help >/dev/null 2>&1"

# Test 5: Create a simple test object and try to link it
print_info "Testing object creation and linking..."

# Create a simple assembly file
cat > test_simple.s << 'EOF'
.section .text
.global _start
_start:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
EOF

# Test assembler (if we have it)
if command -v nasm >/dev/null 2>&1; then
    run_test "Assemble test file" "nasm -f elf32 test_simple.s -o test_simple.o"
    
    if [[ -f test_simple.o ]]; then
        # Test linker
        run_test "Link test file" "./i386-vios-elf-ld test_simple.o -o test_simple"
        
        if [[ -f test_simple ]]; then
            # Test objdump
            run_test "Objdump test file" "./i386-vios-elf-objdump -h test_simple >/dev/null 2>&1"
            
            # Test nm
            run_test "Nm test file" "./i386-vios-elf-nm test_simple >/dev/null 2>&1"
            
            # Test readelf
            run_test "Readelf test file" "./i386-vios-elf-readelf -h test_simple >/dev/null 2>&1"
            
            # Test strip
            run_test "Strip test file" "./i386-vios-elf-strip test_simple"
            
            # Test size
            run_test "Size test file" "./i386-vios-elf-size test_simple >/dev/null 2>&1"
        fi
    fi
    
    # Clean up test files
    rm -f test_simple.s test_simple.o test_simple
else
    print_warning "nasm not available, skipping assembly tests"
fi

# Test 6: Check ViOS libc installation
print_info "Testing ViOS libc installation..."
run_test "ViOS libc directory exists" "test -d /opt/ViOS"
run_test "ViOS libc library exists" "test -f /opt/ViOS/lib/libViOSlibc.a"
run_test "ViOS libc include directory exists" "test -d /opt/ViOS/include"

# Summary
echo "============================================="
print_info "Test Summary:"
print_success "Passed: $PASSED_TESTS tests"
if [[ $FAILED_TESTS -eq 0 ]]; then
    print_success "Failed: $FAILED_TESTS tests"
    print_success "All tests passed!"
    exit 0
else
    print_error "Failed: $FAILED_TESTS tests"
    print_error "Some tests failed!"
    exit 1
fi
