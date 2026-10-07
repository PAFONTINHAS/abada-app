import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';

class SaveClassLocationUsecase {
  final ClassRepository classRepository;

  SaveClassLocationUsecase(this.classRepository);

  Future<Either<Failure, String>> call(LocationEntity locationEntity) async {
    return await classRepository.saveClassLocation(locationEntity);
  }
}
