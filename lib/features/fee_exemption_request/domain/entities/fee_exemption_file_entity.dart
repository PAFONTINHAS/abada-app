import 'dart:typed_data';

class FeeExemptionFileEntity {
  final String fileName;
  final Uint8List bytes;
  //representa os bytes do PDF sem colocar File, Firebase ou Flutter dentro do Domain.

  const FeeExemptionFileEntity({
    required this.fileName,
    required this.bytes,
  });
}