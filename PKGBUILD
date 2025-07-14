# Maintainer: ViOS Development Team <dev@vios.org>
pkgname=vios-binutils
pkgver=1.0.0
pkgrel=1
pkgdesc="Binary utilities for the ViOS operating system (i386-vios-elf target) with integrated libc"
arch=('x86_64' 'i686')
url="https://github.com/PinkQween/ViOS-binutils"
license=('MIT')
depends=('zlib' 'curl')
makedepends=('gcc' 'make')
source=("$pkgname-$pkgver.tar.gz::https://github.com/PinkQween/ViOS-binutils/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')  # This will be updated when you create the release

build() {
    cd "$pkgname-$pkgver"
    make PREFIX=/usr VIOS_PREFIX=/opt/ViOS
}

package() {
    cd "$pkgname-$pkgver"
    make install PREFIX=/usr VIOS_PREFIX=/opt/ViOS DESTDIR="$pkgdir"
    
    # Install license
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    
    # Ensure ViOS libc is properly installed
    if [ -d "$pkgdir/opt/ViOS" ]; then
        echo "ViOS libc installed successfully"
    else
        echo "Warning: ViOS libc installation may have failed"
    fi
}

# Optional: Add check function for testing
check() {
    cd "$pkgname-$pkgver"
    
    # Basic sanity checks
    test -f "i386-vios-elf-ld" || (echo "ld not found" && exit 1)
    test -f "i386-vios-elf-objdump" || (echo "objdump not found" && exit 1)
    test -f "i386-vios-elf-objcopy" || (echo "objcopy not found" && exit 1)
    test -f "i386-vios-elf-ar" || (echo "ar not found" && exit 1)
    test -f "i386-vios-elf-nm" || (echo "nm not found" && exit 1)
    test -f "i386-vios-elf-strip" || (echo "strip not found" && exit 1)
    test -f "i386-vios-elf-size" || (echo "size not found" && exit 1)
    test -f "i386-vios-elf-readelf" || (echo "readelf not found" && exit 1)
    test -f "i386-vios-elf-strings" || (echo "strings not found" && exit 1)
    test -f "i386-vios-elf-as" || (echo "as not found" && exit 1)
    
    # Check linker scripts
    test -f "ldscripts/vios.ld" || (echo "vios.ld not found" && exit 1)
    
    echo "All basic checks passed"
}
