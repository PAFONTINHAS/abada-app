import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/data/datasources/location_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/location/domain/repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository{

  final LocationRemoteDatasource locationRemoteDatasource;

  LocationRepositoryImpl(this.locationRemoteDatasource);
  
  @override
  Future<Either<Failure, LocationEntity>> saveClassLocation(LocationEntity locationEntity) async{
    return await locationRemoteDatasource.saveClassLocation(locationEntity);  
  }

  @override
  Future<Stream<List<LocationEntity>>> getNearbyLocationsStream(double radiusInKm) async{
    return await locationRemoteDatasource.getNearbyLocationsStream(radiusInKm); 
  }

  @override
  Future<Either<Failure, LocationEntity?>> findExistingLocationByOsmKey(String osmKey) async{
    return await locationRemoteDatasource.findExistingLocationByOsmKey(osmKey);
  }

}