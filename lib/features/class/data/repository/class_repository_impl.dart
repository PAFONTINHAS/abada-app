import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDatasource remoteDatasource;

  ClassRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(
    List<String> classesId,
  ) async {
    return await remoteDatasource.getClassesByIdList(classesId);
  }

  @override
  Future<Either<Failure, void>> addStudentToClass(
    String studentId,
    String classId,
  ) async {
    return await remoteDatasource.addStudentToClass(studentId, classId);
  }

  @override
  Stream<QuerySnapshot> getClassesForLocation(String locationId) {
    return remoteDatasource.getClassesForLocation(locationId);
  }

  @override
  Future<Either<Failure, String>> saveClassLocation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    return await remoteDatasource.saveClassLocation(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      userId: userId,
    );
  }

  @override
  Future<Stream<List<DocumentSnapshot>>> getNearbyLocationsStream(
    double radiusInKm,
  ) async {
    return await remoteDatasource.getNearbyLocationsStream(radiusInKm);
  }

  @override
  Future<Either<Failure, ClassEntity>> createClass(ClassEntity classEntity) async{

    return await remoteDatasource.createClass(classEntity);

  }
  @override
  Future<Either<Failure, ClassEntity>> updateClass(ClassEntity classEntity) async{

    return await remoteDatasource.updateClass(classEntity);
  }
}
