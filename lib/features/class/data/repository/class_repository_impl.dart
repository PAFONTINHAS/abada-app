import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/repository/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository{

  final ClassRemoteDatasource remoteDatasource;

  ClassRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(List<String> classesId) async{
    
    return await remoteDatasource.getClassesByIdList(classesId);

  }

}