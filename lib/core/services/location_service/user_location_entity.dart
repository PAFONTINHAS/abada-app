import 'package:geolocator/geolocator.dart';

class UserLocationEntity {

  const UserLocationEntity({
    required this.city,
    required this.state,
    required this.position
  });

  final String? city;
  final String? state;
  final Position position;


}