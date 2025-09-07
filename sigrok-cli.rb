class SigrokCli < Formula
  desc "Command-line frontend for sigrok"
  homepage "https://sigrok.org/wiki/Sigrok-cli"
  url "https://github.com/sigrokproject/sigrok-cli/archive/refs/tags/sigrok-cli-0.7.2.zip"
  sha256 "5eda4c2fa0e80d52faef4c50bc4043936ba4aa164de03a831825f9a0516616a7"
  license "GPL-3.0-or-later"
  head "https://github.com/sigrokproject/sigrok-cli.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "glib" => :build
  depends_on "libftdi" => :build
  depends_on "libusb" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "olegtarasov/sigrok/libsigrok"
  depends_on "olegtarasov/sigrok/libsigrokdecode"
  depends_on "olegtarasov/sigrok/sigrok-firmware-fx2lafw"

  def install
    if build.head? || !File.exist?("configure")
      system "./autogen.sh"
    end
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sigrok-cli", "-L"
  end
end
