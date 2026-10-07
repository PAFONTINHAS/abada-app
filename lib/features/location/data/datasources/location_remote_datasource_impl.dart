import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/database_constants.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/data/models/location_entity_model.dart';
import 'package:sistema_abada_capoeira/features/location/data/datasources/location_remote_datasource.dart';

class LocationRemoteDatasourceImpl implements LocationRemoteDatasource{

  final _firestore = FirebaseFirestore.instance;

  @override 
  Future<Either<Failure, String>> saveClassLocation(LocationEntity locationEntity) async{

    try{

      final GeoFirePoint myLocation = GeoFirePoint(
        GeoPoint(locationEntity.latitude, locationEntity.longitude),
      );

      final collectionReference = _firestore.collection(DBCollections.locationsCollection);
      
      final document = await collectionReference.add({
        'name': locationEntity.name,
        'address': locationEntity.address,
        'position': myLocation.data, 
        'createdBy': locationEntity.createdBy,
        'isVisible': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(document.id);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "saveClassLocation");
    }
  }

  @override
  Future<Stream<List<LocationEntity>>> getNearbyLocationsStream(double radiusInKm) async {

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

      return stream.map((documentList) {
        return documentList
            .map((doc) => LocationEntityModel.fromSnapshot(doc))
            .toList();
      });

    } catch(exception){

      ExceptionHandler.handleException(exception: exception, contextMessage: "getNearbyLocationsStream");

      return Stream.error(exception);

    }
  }

}