import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class AssetFileDownloadService {
  AssetFileDownloadService._();

  static Future<bool> openPdf({
    required String assetPath,
    required String fileName,
  }) async {
    try {
      final byteData = await rootBundle.load(assetPath);

      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      final tempDirectory = await getTemporaryDirectory();

      final file = File(
        '${tempDirectory.path}${Platform.pathSeparator}$fileName',
      );

      await file.writeAsBytes(bytes, flush: true);

      final result = await OpenFilex.open(file.path, type: 'application/pdf');

      return result.type == ResultType.done;
    } catch (exception) {
      debugPrint('Erro ao abrir declaração: $exception');
      return false;
    }
  }
}
