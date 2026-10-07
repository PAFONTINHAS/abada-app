class PlaceSuggestion{

  final String osmKey;
  final String district;
  final double latitude;
  final double longitude;
  final String fullAddress;

  const PlaceSuggestion({
    required this.osmKey,
    required this.latitude,
    required this.district,
    required this.longitude,
    required this.fullAddress,
  });
}