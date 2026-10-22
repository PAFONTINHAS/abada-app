import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path_service;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';

class ImageService {

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async{

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile == null) return null;


    return await compressImage(File(pickedFile.path));
  }


  Future<File?> compressImage(File file) async{

    final temporaryDirectory = await getTemporaryDirectory();

    final targetPath = path_service.join(
      temporaryDirectory.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg'
    );

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minHeight: 1080,
      minWidth: 1080,
      format: CompressFormat.jpeg 
    ).onError((error, stack){
      LoggingService.displayError("Erro ao comprimir imagem: $error, stack: $stack");

    });

    if(result == null) return null;
    return File(result.path);
  }

  Future<String?> uploadEventImage(File imageFile, String fileName, {required String imageCollection}) async{
    try{

      final storageRef = FirebaseStorage.instance.ref().child('$imageCollection/$fileName.jpeg');

      final uploadTask = await storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg')
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    }catch(exception){
      throw Exception("Erro ao salvar imagem: $exception");
    }
  }

}