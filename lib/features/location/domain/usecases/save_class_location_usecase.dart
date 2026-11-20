import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/standard_location_usecase.dart';

class SaveClassLocationUsecase extends StandardLocationUsecase{

  SaveClassLocationUsecase(super.locationRepository);

  Future<Either<Failure, LocationEntity>> call(LocationEntity locationEntity) async {

    final checkIfAddressAlreadyExisits = await locationRepository.findExistingLocationByOsmKey(locationEntity.osmKey);

    return checkIfAddressAlreadyExisits.fold((failure) => Left(failure), (response) async{

      if(response == null) return await locationRepository.saveClassLocation(locationEntity);

      return Right(response);
    });
  }
}
