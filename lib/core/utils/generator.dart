import 'dart:math';

class Generator {
  static String uniqueEventImageName() {
    final random = Random.secure();
    final token = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    return 'rf22-$token';
  }

  Generator._();

  static String generateImageFileName(String requesterId) {
    String shortId = requesterId.length > 5
        ? requesterId.substring(0, 5).toLowerCase()
        : '00000';
    int now = DateTime.now().millisecondsSinceEpoch;

    String shortTime = now.toString().substring(0, 5).toUpperCase();

    return "$shortId$shortTime";
  }
}
