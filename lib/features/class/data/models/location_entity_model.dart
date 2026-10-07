import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/location_entity.dart';

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
      isVisible: data['isVisible']
    );
  }

}