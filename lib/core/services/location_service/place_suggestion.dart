class PlaceSuggestion{

  final String fullAddress;
  final String district;
  final double latitude;
  final double longitude;

  const PlaceSuggestion({
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    required this.district,
  });
}