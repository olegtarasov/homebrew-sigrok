class Micronucleus < Formula
  desc "ATTiny usb bootloader with a strong emphasis on bootloader compactness."
  homepage "https://github.com/micronucleus"
  url "https://github.com/micronucleus/micronucleus/archive/refs/tags/v2.6.zip"
  sha256 "db31ca472647b6399cdbadb042557d9149ca9015dc4cc6e48b74a7b4499847da"
  license "GPL-2.0-or-later"

  depends_on "libusb"
  depends_on "libusb-compat"

  def install
    cd "./commandline" do
      File.open("library/micronucleus_lib.h", "a") do |file|
        file.puts '#define MICRONUCLEUS_COMMANDLINE_VERSION ("micronucleus-cli version: 2.6")'
      end
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
