import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';

class GetAttendedClassesUsecase{

  ClassRepository classRepository;

  GetAttendedClassesUsecase(this.classRepository);

  Future<Either<Failure, List<ClassEntity>>> call(List<String> attendedClassesId) async{

    return await classRepository.getClassesByIdList(attendedClassesId);

  }
}