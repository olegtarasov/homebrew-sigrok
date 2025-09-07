class Micronucleus < Formula
  desc "ATTiny usb bootloader with a strong emphasis on bootloader compactness."
  homepage "https://github.com/micronucleus"
  url "https://github.com/micronucleus/micronucleus.git", branch: "master"
  version :git
  license "GPL-2.0-or-later"

  depends_on "libusb-compat"

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
