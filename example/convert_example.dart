import 'dart:io';
import 'package:convert/convert.dart' as cv;
import 'dart:ffi' as ffi;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<void> main() async {
  final dylib = ffi.DynamicLibrary.open(_getPath());

  final widget = pw.Document();

  widget.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hello World'),
        ); // Center
      }));
  widget.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hello World 2'),
        ); // Center
      }));
  final buffer = await widget.save();

  final path = 'dummy';
  final printing = cv.Printing(dylib);

  printing.raster(path: path, buffer: buffer, pages: [0, 1]);
}

String _getPath() {
  var path = 'target/debug/libraster_pdf.so';
  if (Platform.isMacOS) {
    path = 'target/debug/libraster_pdf.dylib';
  }
  if (Platform.isWindows) {
    path = r'target/debug/libraster_pdf.dll';
  }
  return path;
}
