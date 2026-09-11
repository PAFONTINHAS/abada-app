import 'dart:ui';

class Location {
  final String? address;
  final String? state = "Bucharest";
  final Color? color = const Color(0xFF228B22);
  final String? imagePath;
  final int? action;

  Location({this.address, this.imagePath, this.action});
}
