class Libsigrokdecode < Formula
  desc "python library providing a lot of protocol decoders"
  homepage "https://sigrok.org/wiki/Libsigrokdecode"
  # Head-only
  head "https://github.com/sigrokproject/libsigrokdecode.git", branch: "master"
  license "GPL-3.0-or-later"

  # Use decoders from the external repository by vendoring them into the
  # libsigrokdecode source tree under the `decoders` directory before build.
  resource "sigrok-decoders" do
    url "https://github.com/olegtarasov/sigrok-decoders.git", using: :git
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => [:build, :test]
  depends_on "make" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3"

  def install
    # Single-pass: merge custom decoder directories into the source 'decoders'
    # tree so the project's installer picks them up. On name collisions, the
    # custom decoder overrides the bundled one.
    resource("sigrok-decoders").stage do
      require "fileutils"
      staged_root = Pathname.pwd
      decoders_dir = buildpath/"decoders"
      decoders_dir.mkpath

      dir_entries = Dir.glob('*').select { |e| File.directory?(e) }
      if dir_entries.any?
        dir_entries.each do |d|
          src = staged_root/d
          dst = decoders_dir/d
          FileUtils.rm_rf(dst) if dst.exist?
          FileUtils.cp_r src, decoders_dir
        end
      else
        # If staged into a single decoder directory, copy that directory.
        src = staged_root
        dst = decoders_dir/File.basename(staged_root)
        FileUtils.rm_rf(dst) if dst.exist?
        FileUtils.cp_r src, decoders_dir
      end
    end

    system "sed", "-i", "-e", 's/\[python-3\.[0-9]+-embed\],/[python3-embed],/g', "configure.ac"
    if !File.exist?("configure")
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
