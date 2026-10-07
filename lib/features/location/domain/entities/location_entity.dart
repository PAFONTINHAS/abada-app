class LocationEntity {
  final String id;
  final String name;
  final String address;
  final String district;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;
  final String osmKey;
  final bool isVisible;

  const LocationEntity({
    required this.id,
    required this.name,
    required this.osmKey,
    required this.createdBy,
    required this.address,
    required this.latitude,
    required this.district,
    required this.longitude,
    required this.createdAt,
    this.isVisible = true,
  });

  LocationEntity copyWith({
    String? id,
    String? name,
    String? address,
    String? district,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? createdAt,
    String? osmKey,
    bool? isVisible,
  }){

    return LocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      osmKey: osmKey ?? this.osmKey,
      createdBy: createdBy ?? this.createdBy,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      district: district ?? this.district,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
