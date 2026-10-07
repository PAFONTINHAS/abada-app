class LocationEntity {
  final String id;
  final String name;
  final String address;
  final String district;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;
  final bool isVisible;

  const LocationEntity({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.address,
    required this.latitude,
    required this.district,
    required this.longitude,
    required this.createdAt,
    this.isVisible = true,
  });
}
