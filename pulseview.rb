class Pulseview < Formula
  desc "PulseView is a Qt based logic analyzer, oscilloscope and MSO GUI for sigrok."
  homepage "https://sigrok.org/wiki/PulseView"
  url "https://github.com/sigrokproject/pulseview/archive/refs/tags/pulseview-0.4.2.zip"
  sha256 "3445900e49b69fe44c8bd797524b3ef7351fa5f283ca87fee1fcf52e3dda2c71"
  license "GPL-3.0-or-later"
  head "https://github.com/sigrokproject/pulseview.git"
  
  depends_on build.head? ? "qt" : "qt@5"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib" => :build
  depends_on "libftdi" => :build
  depends_on "libusb" => :build
  depends_on "libzip" => :build
  depends_on "glibmm@2.66" => :build
  depends_on "libsigc++@2" => :build
  depends_on "libserialport" => :build
  depends_on "hidapi" => :build
  depends_on "nettle" => :build
  depends_on "takesako/sigrok/libsigrok"
  depends_on "takesako/sigrok/libsigrokdecode"
  depends_on "takesako/sigrok/sigrok-firmware-fx2lafw"

  stable do
    patch :p1 do
      url "https://raw.githubusercontent.com/takesako/homebrew-sigrok/master/pulseview-0.4.2-qt5.patch"
      sha256 "a53a26e9a003fff717ff9cbaae9e67e1b4acc6edb03bed3cc4ea6d9102f242e3"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-D__GLIB_TYPEOF_H__=", "-DDISABLE_WERROR=y"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pulseview", "-V"
  end
end
