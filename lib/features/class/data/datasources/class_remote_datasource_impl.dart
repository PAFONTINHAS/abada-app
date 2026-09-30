import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/constants/database_constants.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_member_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/data/datasources/class_remote_datasource.dart';

class ClassRemoteDatasourceImpl implements ClassRemoteDatasource{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  Stream<QuerySnapshot> getClassesForLocation(String locationId){


    
    return _firestore
        .collection('classes')
        .where('locationId', isEqualTo: locationId)
        .snapshots();
  }

  @override
  Future<Either<Failure, ClassEntity>> createClass(ClassEntity classEntity) async{

    try{

      final model = ClassEntityModel.fromEntity(classEntity);

      final documentReference = _firestore.collection(DBCollections.classesCollection).doc();

      await documentReference.set(model.toMap());

      LoggingService.displayInfo(model.toMap());

      return Right(model.copyWith(classId: documentReference.id));

    } catch(exception){

      return ExceptionHandler.handleException(exception: exception, contextMessage: "createClass");
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> updateClass(ClassEntity classEntity) async{

    try{

      final model = ClassEntityModel.fromEntity(classEntity);

      final documentReference = _firestore.collection(DBCollections.classesCollection).doc(model.classId);

      await documentReference.update(model.toMap());

      return Right(model);

    } catch(exception){

      return ExceptionHandler.handleException(exception: exception, contextMessage: "updateClass");
    }
  }

  @override 
  Future<Either<Failure, String>> saveClassLocation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String userId,
  }) async{

    try{

      final GeoFirePoint myLocation = GeoFirePoint(GeoPoint(latitude, longitude));

      final collectionReference = _firestore.collection(DBCollections.locationsCollection);
      
      final document = await collectionReference.add({
        'name': name,
        'address': address,
        'position': myLocation.data, // Salva geohash e geopoint juntos
        'createdBy': userId,
        'isVisible': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(document.id);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "saveClassLocation");
    }
  }

  @override
  Future<Stream<List<DocumentSnapshot>>> getNearbyLocationsStream(double radiusInKm) async {

    try{

      // 1. Pega a localização atual do celular do aluno
      Position position = await Geolocator.getCurrentPosition();

      GeoFirePoint center = GeoFirePoint(
        GeoPoint(
          position.latitude,
          position.longitude,
        )
      );

      // 2. Consulta no Firestore em tempo real todas as academias no raio definido (ex: 10km)
      var collectionRef = _firestore.collection(DBCollections.locationsCollection);

      GeoPoint geoPointFrom(Map<String, dynamic> data) {
        final position = data['position'] as Map<String, dynamic>;
        return position['geopoint'] as GeoPoint;
      }

      final Stream<List<DocumentSnapshot<Map<String,dynamic>>>> stream = GeoCollectionReference(collectionRef).subscribeWithin(
        center: center,
        radiusInKm: radiusInKm,
        field: 'position',
        strictMode: true,
        geopointFrom: geoPointFrom
      );

      return stream;
    } catch(exception){

      ExceptionHandler.handleException(exception: exception, contextMessage: "getNearbyLocationsStream");

      return Stream.error(exception);

    }
  }


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