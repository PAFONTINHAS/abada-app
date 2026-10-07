import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/standard_location_usecase.dart';

class GetNearbyLocationsStreamUsecase extends StandardLocationUsecase{

  GetNearbyLocationsStreamUsecase(super.locationRepository);

  Future<Stream<List<LocationEntity>>> call(double radiusInKm) async {
    return await locationRepository.getNearbyLocationsStream(radiusInKm);
  }

}