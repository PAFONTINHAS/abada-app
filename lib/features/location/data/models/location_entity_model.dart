import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';

class LocationEntityModel extends LocationEntity{

  const LocationEntityModel({
    required super.id,
    required super.name,
    required super.createdBy,
    required super.address,
    required super.latitude,
    required super.district,
    required super.longitude,
    required super.createdAt,
    required super.osmKey,
    super.isVisible
  });


  factory LocationEntityModel.fromSnapshot(DocumentSnapshot doc){
    
    final data = doc.data() as Map<String,dynamic>? ?? {};

    final position = data['position'] as Map<String, dynamic>? ?? {};

    final geoPoint = position['geopoint'] as GeoPoint? ?? const GeoPoint(0, 0);
    
    final createdAt = (data['createdAt'] as Timestamp).toDate();

    return LocationEntityModel(
      id: doc.id,
      name: data['name'],
      address: data['address'],
      district: data['district'],
      createdAt: createdAt,
      createdBy: data['createdBy'],
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      osmKey: data['osmKey'] ?? '',
      isVisible: data['isVisible']
    );
  }

  factory LocationEntityModel.fromEntity(LocationEntity entity){

    return LocationEntityModel(
      id: entity.id,
      name: entity.name,
      createdBy: entity.createdBy,
      address: entity.address,
      latitude: entity.latitude,
      district: entity.district,
      longitude: entity.longitude,
      createdAt: entity.createdAt,
      osmKey: entity.osmKey,
    );
  }

  Map<String, dynamic> toMap(){

    return {
      'name': name,
      'createdBy': createdBy,
      'address': address,
      'district': district,
      'createdAt': createdAt,
      'osmKey': osmKey,
      'isVisible': isVisible
    };
  }

}