import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/location_entity.dart';

abstract class ClassRemoteDatasource {

  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(List<String> classesId);
  Future<Either<Failure, void>> addStudentToClass(String studentId, String classId);
  Stream<List<ClassEntity>> getClassesForLocation(String locationId);
  Future<Either<Failure, String>> saveClassLocation(LocationEntity locationEntity);
  Future<Stream<List<LocationEntity>>> getNearbyLocationsStream(double radiusInKm);
  Future<Either<Failure, ClassEntity>> createClass(ClassEntity classEntity);
  Future<Either<Failure, ClassEntity>> updateClass(ClassEntity classEntity);


}