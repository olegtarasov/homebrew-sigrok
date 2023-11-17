# Based on rob-deutsch's branch
# https://github.com/rob-deutsch/homebrew-core/tree/sigrok
class SigrokCli < Formula
  desc "Command-line frontend for sigrok"
  homepage "https://sigrok.org/wiki/Sigrok-cli"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.0.tar.gz"
  sha256 "5669d968c2de3dfc6adfda76e83789b6ba76368407c832438cef5e7099a65e1c"
  head "git://sigrok.org/sigrok-cli"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "glib" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "takesako/sigrok/libsigrok"
  depends_on "takesako/sigrok/libsigrokdecode"

  def install
    if !File.exist?("configure") && File.exist?("autogen.sh") then
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
