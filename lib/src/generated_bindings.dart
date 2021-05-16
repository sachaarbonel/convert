
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

extension Uint8ListPointer on Uint8List {
  // https://github.com/dart-lang/ffi/issues/31
  // Workaround: before does not allow direct pointer exposure
  Pointer<ffi.Uint8> getPointer() {
    final ptr = malloc.allocate<Uint8>(length);
    final typedList = ptr.asTypedList(length);
    typedList.setAll(0, this);
    return ptr.cast();
  }
}

/// Bindings to `headers/raster_pdf.h`.
class Printing {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  Printing(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  Printing.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void raster_pdf(
      ffi.Pointer<ffi.Uint8> data, int size, ffi.Pointer<Utf8> path) {
    return _raster_pdf(
      data,
      size,
      path,
    );
  }

  late final _raster_pdf_ptr =
      _lookup<ffi.NativeFunction<_c_raster_pdf>>('raster_pdf');
  late final _dart_raster_pdf _raster_pdf =
      _raster_pdf_ptr.asFunction<_dart_raster_pdf>();
}

typedef _c_raster_pdf = ffi.Void Function(
    ffi.Pointer<ffi.Uint8> data, ffi.Int32 size, ffi.Pointer<Utf8> path);

typedef _dart_raster_pdf = void Function(
  ffi.Pointer<ffi.Uint8> data,
  int size,
  ffi.Pointer<Utf8> path,
);