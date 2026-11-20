import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/user_location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/domain/usecases/standard_location_usecase.dart';

class GetUserLocationUsecase extends StandardLocationUsecase{

  GetUserLocationUsecase(super.locationRepository);


  Future<Either<Failure, UserLocationEntity>> call() async{
    return await locationRepository.getUserLocation();
  }

}