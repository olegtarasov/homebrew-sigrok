class SigrokCli < Formula
  desc "Command-line frontend for sigrok"
  homepage "https://sigrok.org/wiki/Sigrok-cli"
  url "https://github.com/sigrokproject/sigrok-cli.git", branch: "master"
  version "HEAD-20250907"
  license "GPL-3.0-or-later"

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
    if !File.exist?("configure")
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
