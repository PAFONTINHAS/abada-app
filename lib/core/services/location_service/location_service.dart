import 'dart:convert';

import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'package:http/http.dart' as http;

class LocationService {

  static Future<List<PlaceSuggestion>> searchAddress(String query) async{

    if(query.length < 3) return [];

    final url = Uri.parse(
      'https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&lang=en&limit=5',
    );

    final response = await http.get(url);

    if(response.statusCode != 200) return [];

    final data = json.decode(response.body);
    final features = data['features'] as List;

    return features.map((feature){

      final properties = feature['properties'];
      final geometry = feature['geometry']['coordinates'];

      final double longitude = geometry[0];
      final double latitude = geometry[1];

      final name = properties['name'] ?? '';
      final street = properties['street'] ?? '';
      final city = properties['city'] ?? '';
      final state = properties['state'] ?? '';

      final fullAddress = [name, street, city, state]
        .where((element) => element.toString().isNotEmpty)
        .join(', ');

      return PlaceSuggestion(description: fullAddress, latitude: latitude, longitude: longitude);  
    }).toList();
  }
}