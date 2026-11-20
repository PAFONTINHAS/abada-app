import 'package:geolocator/geolocator.dart';
import './coordinates_entity.dart';

class UserLocationEntity {

  const UserLocationEntity({
    required this.city,
    required this.state,
    required this.position,
    required this.cityCenterCoordinates
  });

  final String? city;
  final String? state;
  final Position position;
  final CoordinatesEntity? cityCenterCoordinates;



}