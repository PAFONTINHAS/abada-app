import 'dart:typed_data';

class PickedFileData {
  final String fileName;
  final Uint8List bytes;

  const PickedFileData({
    required this.fileName,
    required this.bytes,
  });
}