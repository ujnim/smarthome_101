import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleApiService {
  static const String _placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place/textsearch/json';
  static const String _geocodingBaseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static final String? _apiKey = dotenv.env['GOOGLE_API_KEY']; // Read the API key

  Future<Map<String, dynamic>> getPlaceInfo(String query) async {
    final response = await http.get(
      Uri.parse('$_placesBaseUrl?query=$query&key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getGeocodeInfo(String address) async {
    final response = await http.get(
      Uri.parse('$_geocodingBaseUrl?address=$address&key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
