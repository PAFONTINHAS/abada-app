import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

abstract class ClassRepository {

  Future<Either<Failure, void>> addStudentToClass(String studentId, String classId);
  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(List<String> classesId);

}