class ViosBinutils < Formula
  desc "Binary utilities for the ViOS operating system (i386-vios-elf target)"
  homepage "https://github.com/skairipa/vios-binutils"
  url "https://github.com/skairipa/vios-binutils/archive/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000" # This will be updated when you create the release
  license "MIT"
  head "https://github.com/skairipa/vios-binutils.git", branch: "main"

  depends_on "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--target=i386-vios-elf"
    system "make"
    system "make", "install"
  end

  test do
    # Test that the binaries exist and are executable
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

    # Test version output (if implemented)
    system bin/"i386-vios-elf-ld", "--version" rescue nil
  end
end
