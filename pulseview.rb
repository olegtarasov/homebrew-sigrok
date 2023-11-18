class Pulseview < Formula
  desc "PulseView is a Qt based logic analyzer, oscilloscope and MSO GUI for sigrok."
  homepage "https://sigrok.org/wiki/PulseView"
  url "https://github.com/sigrokproject/pulseview/archive/refs/tags/pulseview-0.4.2.zip"
  sha256 "f042f77a3e1b35bf30666330e36ec38fab8d248c3693c37b7e35d401c3bfabcb"
  license "GPL-3.0-or-later"
  head "https://github.com/sigrokproject/pulseview.git"
  
  depends_on "qt"
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

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DDISABLE_WERROR=y"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pulseview", "-V"
  end
end
