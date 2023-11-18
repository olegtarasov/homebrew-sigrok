class SigrokFirmwareFx2lafw < Formula
  desc "Open-source firmware for Cypress FX2 chips"
  homepage "https://sigrok.org/wiki/Fx2lafw"
  url "https://github.com/sigrokproject/sigrok-firmware-fx2lafw/archive/refs/tags/sigrok-firmware-fx2lafw-0.1.7.tar.gz"
  sha256 "a3f440d6a852a46e2c5d199fc1c8e4dacd006bc04e0d5576298ee55d056ace3b"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/sigrokproject/sigrok-firmware-fx2lafw.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "make" => :build
  depends_on "sdcc" => :build

  def install
    system 'perl -i -pe "s/(\s__interrupt)\s+(\w+)/\1(\2)/" fx2lafw.c fx2lib/include/autovector.h fx2lib/lib/interrupts/*.c include/scope.inc'
    system 'perl -i -pe "s/(__sbit\s+__at)\s+(0x[a-fA-F\d]+\s*\+\s*\d)\s+/\1(\2) /" fx2lib/include/fx2regs.h'
    if build.head?
      system "./autogen.sh"
    end
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "ls", "-1", "#{share}/sigrok-firmware/"
  end
end
