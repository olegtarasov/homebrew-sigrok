class Libsigrokdecode < Formula
  desc "python library providing a lot of protocol decoders"
  homepage "https://sigrok.org/wiki/Libsigrokdecode"
  url "https://github.com/sigrokproject/libsigrokdecode/archive/refs/tags/libsigrokdecode-0.5.3.zip"
  sha256 "e0a8042722c1a992c3d2e1c3827afa5e0f45c9e1af8ceec225af229758f6cef5"
  license "GPL-3.0-or-later"
  head "https://github.com/sigrokproject/libsigrokdecode.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => [:build, :test]
  depends_on "make" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"

  head do
    depends_on "python@3"
  end

  stable do
    depends_on "python@3.8"
  end

  def install
    system "sed", "-i", "-e", 's/\[python-3\.[0-9]+-embed\],/[python3-embed],/g', "configure.ac"
    if build.head? || !File.exist?("configure")
      system "./autogen.sh"
    else
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libsigrokdecode/libsigrokdecode.h>
      #include <glib.h>

      int main(int argc, char **argv)
      {
        int ret;
        if ((ret = srd_init(NULL)) != SRD_OK) {
          printf("Error initializing libsigrokdecode (%s): %s.",
                  srd_strerror_name(ret), srd_strerror(ret));
          return 1;
        }
        srd_decoder_load_all();
        const GSList* decoders = srd_decoder_list();
        if (!decoders) {
          printf("Error listing decoders");
          return 1;
        };
        guint num_decoders = g_slist_length((GSList *)decoders);
        if (num_decoders == 0) {
          printf("No decoders listed");
          return 1;
        };
        return 0;
      }
    EOS
    pkg_config_flags = `pkg-config --cflags --libs libsigrokdecode`.chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
