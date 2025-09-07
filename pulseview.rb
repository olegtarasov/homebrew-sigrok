class Pulseview < Formula
  desc "PulseView is a Qt based logic analyzer, oscilloscope and MSO GUI for sigrok."
  homepage "https://sigrok.org/wiki/PulseView"
  url "https://github.com/sigrokproject/pulseview.git", branch: "master"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib" => :build
  depends_on "libftdi" => :build
  depends_on "libusb" => :build
  depends_on "libzip" => :build
  depends_on "glibmm" => :build
  depends_on "libsigc++" => :build
  depends_on "libserialport" => :build
  depends_on "hidapi" => :build
  depends_on "nettle" => :build
  depends_on "qt"
  depends_on "olegtarasov/sigrok/libsigrok"
  depends_on "olegtarasov/sigrok/libsigrokdecode"
  depends_on "olegtarasov/sigrok/sigrok-firmware-fx2lafw"

  def install
    cmakelists = buildpath/"CMakeLists.txt"
    if cmakelists.exist? && cmakelists.read.include?("set(BOOSTCOMPS filesystem serialization system)")
      ohai "Patching BOOSTCOMPS in #{cmakelists}"
      inreplace cmakelists,
                "set(BOOSTCOMPS filesystem serialization system)",
                "set(BOOSTCOMPS filesystem serialization)"
    end
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
