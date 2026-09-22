import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

abstract class ClassRemoteDatasource {

  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(List<String> classesId);
  Future<Either<Failure, void>> addStudentToClass(String studentId, String classId);
  Stream<QuerySnapshot> getClassesForLocation(String locationId);
  Future<Either<Failure, void>> saveClassLocation({
      required String name,
      required String address,
      required double latitude,
      required double longitude,
      required String userId,
  });

  Future<Stream<List<DocumentSnapshot>>> getNearbyLocationsStream(double radiusInKm);

}