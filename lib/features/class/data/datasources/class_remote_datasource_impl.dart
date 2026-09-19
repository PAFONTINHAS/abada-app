import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_member_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class ClassRemoteDatasourceImpl implements ClassRemoteDatasource{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  Future<Either<Failure, List<ClassEntity>>> getClassesByIdList(List<String> classesId) async{

    try{

      if(classesId.isEmpty) return Right([]);

      final snapshots = await _firestore
          .collection('classes')
          .where(FieldPath.documentId, whereIn: classesId)
          .get();

      final List<ClassEntity> classes = [];

      for(final classDocument in snapshots.docs){

        ClassEntityModel classEntityModel = ClassEntityModel.fromSnapshot(classDocument);

        final membersSnapshots = await _firestore.collection('classes').doc(classDocument.id).collection("students").get();

        List<ClassMemberEntity> members = [];


        for(final memberDocument in membersSnapshots.docs){
          

          final memberEntityModel = ClassMemberEntityModel.fromSnapshot(memberDocument);

          members.add(memberEntityModel);
        }

        classEntityModel = classEntityModel.copyWith(members: members);
        classes.add(classEntityModel);
      }

      return Right(classes);

    } catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "getClassesByIdList");
    }
  }  

  @override
  Future<Either<Failure, void>> addStudentToClass(String studentId, String classId) async{

    try{

      final callable = _functions.httpsCallable("approveMemberRequestAndAddToClass");

      await callable.call({
        'memberId': studentId,
        'classId': classId
      });

      return Right(null);

    }catch(exception){

      return ExceptionHandler.handleException(exception: exception, contextMessage: "addStudentToClass");
    }



  }


}