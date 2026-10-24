import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/user_location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';

abstract class LocationRepository {


  Future<Either<Failure, LocationEntity>> saveClassLocation(LocationEntity locationEntity);
  Future<Stream<List<LocationEntity>>> getNearbyLocationsStream(double radiusInKm);
  Future<Either<Failure, LocationEntity?>> findExistingLocationByOsmKey(String osmKey);
  Future<Either<Failure, UserLocationEntity>> getUserLocation();


}