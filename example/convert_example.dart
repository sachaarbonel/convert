import 'dart:io';
import 'package:convert/convert.dart' as cv;
import 'dart:ffi' as ffi;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:ffi/ffi.dart';

Future<void> main() async {
  final dylib = ffi.DynamicLibrary.open(_getPath());

  final widget = pw.Document();

  widget.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hello World'),
        ); // Center
      })); // Page
  final buffer = await widget.save();

  final path = 'dummy.jpeg';
  final pathPointer = path.toNativeUtf8();
  final printing = cv.Printing(dylib);
  printing.raster_pdf(
      buffer.getPointer(), buffer.buffer.lengthInBytes, pathPointer);
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
