class ViosBinutils < Formula
  desc "Binary utilities for the ViOS operating system (i386-vios-elf target) with integrated libc"
  homepage "https://github.com/PinkQween/ViOS-binutils"
  url "https://github.com/PinkQween/ViOS-binutils/archive/v1.0.0.tar.gz"
  sha256 "" # Will be calculated from the actual release
  license "MIT"
  head "https://github.com/PinkQween/ViOS-binutils.git", branch: "main"

  depends_on "zlib"
  depends_on "curl"

  def install
    # Build and install with integrated ViOS libc
    system "make", "PREFIX=#{prefix}", "VIOS_PREFIX=#{prefix}/vios"
    system "make", "install", "PREFIX=#{prefix}", "VIOS_PREFIX=#{prefix}/vios", "DESTDIR=#{prefix}"
  end

  test do
    # Test that the binaries exist and are executable
    assert_predicate bin/"i386-vios-elf-gcc", :exist?
    assert_predicate bin/"i386-vios-elf-ld", :exist?
    assert_predicate bin/"i386-vios-elf-objdump", :exist?
    assert_predicate bin/"i386-vios-elf-objcopy", :exist?
    assert_predicate bin/"i386-vios-elf-ar", :exist?
    assert_predicate bin/"i386-vios-elf-strip", :exist?
    assert_predicate bin/"i386-vios-elf-nm", :exist?
    assert_predicate bin/"i386-vios-elf-size", :exist?
    assert_predicate bin/"i386-vios-elf-readelf", :exist?
    assert_predicate bin/"i386-vios-elf-strings", :exist?
    assert_predicate bin/"i386-vios-elf-as", :exist?

    # Test that the linker script exists
    assert_predicate lib/"ldscripts/vios.ld", :exist?

    # Test that ViOS libc is installed
    assert_predicate prefix/"vios/lib/libViOSlibc.a", :exist?
    assert_predicate prefix/"vios/include", :exist?

    # Test version output (if implemented)
    system bin/"i386-vios-elf-ld", "--version" rescue nil
  end
end
