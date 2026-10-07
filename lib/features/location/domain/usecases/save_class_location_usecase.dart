import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/standard_location_usecase.dart';

class SaveClassLocationUsecase extends StandardLocationUsecase{

  SaveClassLocationUsecase(super.locationRepository);

  Future<Either<Failure, String>> call(LocationEntity locationEntity) async {
    return await locationRepository.saveClassLocation(locationEntity);
  }
}
