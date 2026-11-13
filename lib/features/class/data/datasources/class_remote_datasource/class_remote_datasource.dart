import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

abstract class ClassRemoteDatasource {

  Stream<List<ClassEntity>> getClassesForLocation(String locationId);
  Future<Either<Failure, ClassEntity>> createClass(ClassEntity classEntity);
  Future<Either<Failure, ClassEntity>> updateClass(ClassEntity classEntity);
  Future<Either<Failure, void>> addStudentToClass(String studentId, String classId);
  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(List<String> classesId);
  Future<Either<Failure, void>> removeStudentFromClass(String studentId, String classId);



}