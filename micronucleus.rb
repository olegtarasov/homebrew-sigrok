class Micronucleus < Formula
  desc "ATTiny usb bootloader with a strong emphasis on bootloader compactness."
  homepage "https://github.com/micronucleus"
  url "https://github.com/micronucleus/micronucleus/archive/refs/tags/v2.6.zip"
  sha256 "db31ca472647b6399cdbadb042557d9149ca9015dc4cc6e48b74a7b4499847da"
  license "GPL-2.0-or-later"
  head "https://github.com/micronucleus/micronucleus.git"

  depends_on "libusb-compat"

  stable do
    patch :DATA
  end

  def install
    cd "commandline" do
      ENV["USBFLAGS"] = `libusb-config --cflags`.chomp
      ENV["USBLIBS"]  = `libusb-config --libs`.chomp
      system "make"
      bin.install "micronucleus"
    end
  end

  test do
    system "#{bin}/micronucleus", "--help"
  end
  
end

__END__
--- _head_/commandline/library/micronucleus_lib.h  2024-05-08 20:46:49
+++ stable/commandline/library/micronucleus_lib.h  2024-05-15 21:12:27
@@ -124,0 +125 @@
+#define MICRONUCLEUS_COMMANDLINE_VERSION ("micronucleus-cli version: 2.6")
