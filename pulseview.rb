class Pulseview < Formula
  desc "PulseView is a Qt based logic analyzer, oscilloscope and MSO GUI for sigrok."
  homepage "https://sigrok.org/wiki/PulseView"
  url "https://github.com/sigrokproject/pulseview/archive/refs/tags/pulseview-0.4.2.zip"
  sha256 "3445900e49b69fe44c8bd797524b3ef7351fa5f283ca87fee1fcf52e3dda2c71"
  license "GPL-3.0-or-later"
  head "https://github.com/sigrokproject/pulseview.git"
  
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
  depends_on "olegtarasov/sigrok/libsigrok"
  depends_on "olegtarasov/sigrok/libsigrokdecode"
  depends_on "olegtarasov/sigrok/sigrok-firmware-fx2lafw"

  head do
    depends_on "qt"
  end

  stable do
    depends_on "qt@5"
    patch :p1, :DATA
  end

  def install
    if build.head?
      cmakelists = buildpath/"CMakeLists.txt"
      if cmakelists.exist? && cmakelists.read.include?("set(BOOSTCOMPS filesystem serialization system)")
        ohai "Patching BOOSTCOMPS in #{cmakelists}"
        inreplace cmakelists,
                  "set(BOOSTCOMPS filesystem serialization system)",
                  "set(BOOSTCOMPS filesystem serialization)"
      end
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DDISABLE_WERROR=y"
      if build.stable?
        # ENV.append_to_cflags "-D__GLIB_TYPEOF_H__"
        system "sed", "-i", "-e", 's/CXX_FLAGS = /CXX_FLAGS=-D__GLIB_TYPEOF_H__ /g', "CMakeFiles/pulseview.dir/flags.make"
      end
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pulseview", "-V"
  end
end

__END__
diff -ur pulseview-pulseview-0.4.2/pv/subwindows/decoder_selector/subwindow.cpp pulseview-pulseview-0.4.2-patch/pv/subwindows/decoder_selector/subwindow.cpp
--- pulseview-pulseview-0.4.2/pv/subwindows/decoder_selector/subwindow.cpp	2020-04-01 05:39:16.000000000 +0900
+++ pulseview-pulseview-0.4.2-patch/pv/subwindows/decoder_selector/subwindow.cpp	2023-11-25 17:03:46.000000000 +0900
@@ -185,7 +185,7 @@
 int SubWindow::minimum_width() const
 {
 	QFontMetrics m(info_label_body_->font());
-	const int label_width = m.width(QString(tr(initial_notice)));
+	const int label_width = util::text_width(m, tr(initial_notice));
 
 	return label_width + min_width_margin;
 }
diff -ur pulseview-pulseview-0.4.2/pv/util.cpp pulseview-pulseview-0.4.2-patch/pv/util.cpp
--- pulseview-pulseview-0.4.2/pv/util.cpp	2020-04-01 05:39:16.000000000 +0900
+++ pulseview-pulseview-0.4.2-patch/pv/util.cpp	2023-11-25 17:03:46.000000000 +0900
@@ -137,7 +137,7 @@
 	QString s;
 	QTextStream ts(&s);
 	if (sign && !v.is_zero())
-		ts << forcesign;
+		ts.setNumberFlags(ts.numberFlags() | QTextStream::ForceSign);
 	ts << qSetRealNumberPrecision(precision) << (v * multiplier);
 	ts << ' ' << prefix << unit;
 
@@ -175,7 +175,7 @@
 	QString s;
 	QTextStream ts(&s);
 	if (sign && (v != 0))
-		ts << forcesign;
+		ts.setNumberFlags(ts.numberFlags() | QTextStream::ForceSign);
 	ts.setRealNumberNotation(QTextStream::FixedNotation);
 	ts.setRealNumberPrecision(precision);
 	ts << (v * multiplier) << ' ' << prefix << unit;
@@ -285,5 +285,22 @@
 	return result;
 }
 
+/**
+ * Return the width of a string in a given font.
+ *
+ * @param[in] metric metrics of the font
+ * @param[in] string the string whose width should be determined
+ *
+ * @return width of the string in pixels
+ */
+std::streamsize text_width(const QFontMetrics &metric, const QString &string)
+{
+#if QT_VERSION >= QT_VERSION_CHECK(5, 11, 0)
+	return metric.horizontalAdvance(string);
+#else
+	return metric.width(string);
+#endif
+}
+
 } // namespace util
 } // namespace pv
diff -ur pulseview-pulseview-0.4.2/pv/util.hpp pulseview-pulseview-0.4.2-patch/pv/util.hpp
--- pulseview-pulseview-0.4.2/pv/util.hpp	2020-04-01 05:39:16.000000000 +0900
+++ pulseview-pulseview-0.4.2-patch/pv/util.hpp	2023-11-25 17:03:46.000000000 +0900
@@ -30,6 +30,7 @@
 
 #include <QMetaType>
 #include <QString>
+#include <QFontMetrics>
 
 using std::string;
 using std::vector;
@@ -138,6 +139,15 @@
 
 vector<string> split_string(string text, string separator);
 
+/**
+ * Return the width of a string in a given font.
+ * @param[in] metric metrics of the font
+ * @param[in] string the string whose width should be determined
+ *
+ * @return width of the string in pixels
+ */
+std::streamsize text_width(const QFontMetrics &metric, const QString &string);
+
 } // namespace util
 } // namespace pv
 
diff -ur pulseview-pulseview-0.4.2/pv/views/trace/decodetrace.cpp pulseview-pulseview-0.4.2-patch/pv/views/trace/decodetrace.cpp
--- pulseview-pulseview-0.4.2/pv/views/trace/decodetrace.cpp	2020-04-01 05:39:16.000000000 +0900
+++ pulseview-pulseview-0.4.2-patch/pv/views/trace/decodetrace.cpp	2023-11-25 17:03:46.000000000 +0900
@@ -164,7 +164,8 @@
 
 	// Determine shortest string we want to see displayed in full
 	QFontMetrics m(QApplication::font());
-	min_useful_label_width_ = m.width("XX"); // e.g. two hex characters
+	// e.g. two hex characters
+	min_useful_label_width_ = util::text_width(m, "XX");
 
 	default_row_height_ = (ViewItemPaintParams::text_height() * 6) / 4;
 	annotation_height_ = (ViewItemPaintParams::text_height() * 5) / 4;
diff -ur pulseview-pulseview-0.4.2/pv/views/trace/ruler.cpp pulseview-pulseview-0.4.2-patch/pv/views/trace/ruler.cpp
--- pulseview-pulseview-0.4.2/pv/views/trace/ruler.cpp	2020-04-01 05:39:16.000000000 +0900
+++ pulseview-pulseview-0.4.2-patch/pv/views/trace/ruler.cpp	2023-11-25 17:03:46.000000000 +0900
@@ -283,7 +283,7 @@
 		const int rightedge = width();
 		const int x_tick = tick.first;
 		if ((x_tick > leftedge) && (x_tick < rightedge)) {
-			const int x_left_bound = QFontMetrics(font()).width(tick.second) / 2;
+			const int x_left_bound = util::text_width(QFontMetrics(font()), tick.second) / 2;
 			const int x_right_bound = rightedge - x_left_bound;
 			const int x_legend = min(max(x_tick, x_left_bound), x_right_bound);
 			p.drawText(x_legend, ValueMargin, 0, text_height,
diff -ur pulseview-pulseview-0.4.2/pv/widgets/timestampspinbox.cpp pulseview-pulseview-0.4.2-patch/pv/widgets/timestampspinbox.cpp
--- pulseview-pulseview-0.4.2/pv/widgets/timestampspinbox.cpp	2020-04-01 05:39:16.000000000 +0900
+++ pulseview-pulseview-0.4.2-patch/pv/widgets/timestampspinbox.cpp	2023-11-25 17:03:46.000000000 +0900
@@ -76,7 +76,7 @@
 {
 	const QFontMetrics fm(fontMetrics());
 	const int l = round(value_).str().size() + precision_ + 10;
-	const int w = fm.width(QString(l, '0'));
+	const int w = util::text_width(fm, QString(l, '0'));
 	const int h = lineEdit()->minimumSizeHint().height();
 	return QSize(w, h);
 }
