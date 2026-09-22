import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';

class SaveClassLocationUsecase {

  final ClassRepository classRepository;

  SaveClassLocationUsecase(this.classRepository);

  Future<Either<Failure, void>> call({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String userId,
  }) async{


    return await classRepository.saveClassLocation(name: name, address: address, latitude: latitude, longitude: longitude, userId: userId);



  }


}