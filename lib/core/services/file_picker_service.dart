import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class PickedFileData {
  final String fileName;
  final Uint8List bytes;

  const PickedFileData({
    required this.fileName,
    required this.bytes,
  });
}

class FilePickerService {
  FilePickerService._();

  static Future<PickedFileData?> pickPdf() async {
    final pickedFile = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile == null) {
      return null;
    }

    final bytes = await pickedFile.readAsBytes();

    return PickedFileData(
      fileName: pickedFile.name,
      bytes: bytes,
    );
  }
}