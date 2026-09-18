import 'package:file_picker/file_picker.dart';
import 'package:sistema_abada_capoeira/core/services/picked_file_data.dart';
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