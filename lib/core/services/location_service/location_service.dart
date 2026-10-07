import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';

class LocationService {

  Future<void> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      LoggingService.displayInfo('Location services are disabled.');
      return;
    }

    // 2. Check current permission status
    permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // 3. Request permission if it was previously denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        LoggingService.displayInfo('Location permissions are denied.');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // The user permanently denied permissions; prompt them to open settings
      LoggingService.displayInfo('Location permissions are permanently denied.');
      // Optional: await Geolocator.openAppSettings();
      return;
    } 

  }

  
  final http.Client client;

  LocationService({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<PlaceSuggestion>> searchAddress(String query) async {

    LoggingService.displayInfo("[SERVICE] Searching for $query");
    if (query.trim().length < 3) return [];

    final url = Uri.parse(
      'https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&lang=en&limit=5',
    );

    LoggingService.displayInfo("URL: $url");


    try {
      final response = await client.get(
        
        url,
        headers: {
          'User-Agent': 'AppAbadaCapoeiraTCC/1.0 (petersonfontinhas@gmail.com)',
          'Accept': 'application/json',
        }
      );
      

      LoggingService.displayInfo("[SERVICE] Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        LoggingService.displayInfo("[SERVICE] Address found");

        final data = json.decode(utf8.decode(response.bodyBytes));
        final features = data['features'] as List;

        return features.map((feature) {
          final props = feature['properties'];
          final geometry = feature['geometry']['coordinates'];

          // Photon retorna GeoJSON no padrão [longitude, latitude]
          final double lng = (geometry[0] as num).toDouble();
          final double lat = (geometry[1] as num).toDouble();

          final name = props['name'] ?? '';
          final street = props['street'] ?? '';
          final city = props['city'] ?? '';
          final state = props['state'] ?? '';
          final district = props['district'] ?? '';
          final houseNumber = props['housenumber'] ?? '';
          final postCode = props['postcode'] ?? '';
          final osmType = props['osm_type'] ?? '';
          final osmId = props['osm_id'] ?? '';

          final osmKey = "${osmType}_$osmId";

          final fullAddress = "$name - $street, $houseNumber - $district, $city - $state, $postCode";

          return PlaceSuggestion(
            latitude: lat,
            osmKey: osmKey,
            longitude: lng,
            district: district,
            fullAddress: fullAddress,
          );
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}