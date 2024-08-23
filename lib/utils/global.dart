import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserDataField {
  uid,
  email,
  displayName,
  phoneNumber,
}

Locale getDeviceLocale() {
  // ignore: deprecated_member_use
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  // return Locale(locale.languageCode.toLowerCase(), locale.countryCode ?? '');
  return locale;

  // return WidgetsBinding.instance.window.locale;
}

String? getCurrentUser() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

String? getCurrentUserData(UserDataField field) {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return null; // Return null if the user is not logged in.
  }

  switch (field) {
    case UserDataField.uid:
      return user.uid;
    case UserDataField.email:
      return user.email;
    case UserDataField.displayName:
      return user.displayName;
    case UserDataField.phoneNumber:
      return user.phoneNumber;
    default:
      return null; // Handle any unexpected cases.
  }
}

class AddressUtils {
  static Future<String> getAddress(
    double lat,
    double long, {
    bool quarter = false,
    bool suburb = false,
    bool district = false,
    bool city = false,
    bool state = false,
    bool country = false,
    required String localeCode,
  }) async {
    // final locale = getDeviceLocale().languageCode;
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&accept-language=$localeCode');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['address'] != null) {
        final address = data['address'];
        // Combine parts of the address as needed
        final addressString = [
          quarter
              ? address.containsKey('quarter')
                  ? address['quarter']
                  : null
              : null,
          suburb
              ? address.containsKey('suburb')
                  ? address['suburb']
                  : null
              : null,
          district
              ? address.containsKey('district')
                  ? address['district']
                  : null
              : null,
          city
              ? address.containsKey('city')
                  ? address['city']
                  : null
              : null,
          state
              ? address.containsKey('state')
                  ? address['state']
                  : null
              : null,
          country
              ? address.containsKey('country')
                  ? address['country']
                  : null
              : null,
        ].where((part) => part != null).join(', ');

        return removeUnwantedDetails(addressString);
      }
    }
    return "Unable to fetch address";
  }

  static String removeUnwantedDetails(String address) {
    // Regular expression to remove unwanted details
    final unwantedRegex = RegExp(
      r'(?:แขวง|เขต|ตำบล|อำเภอ|เขตการปกครอง|แขวงการปกครอง|District|Subdistrict|Neighborhood|County|City|State|Province|Prefecture|Region|Municipality|Town|Village|Ward|Area|Sector|Zone|Block|Quarter)\s*\w*|^\d+/\d+|,?\s*ประเทศไทย$',
      caseSensitive: false,
      unicode: true,
    );

    // Replace unwanted parts
    final cleanedAddress = address.replaceAll(unwantedRegex, '').trim();

    return cleanedAddress;
  }
}

Future<Position> getLocationDevice() async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, return an error or handle accordingly
    throw Exception('Location services are disabled.');
  }

  // Check for location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, return an error or handle accordingly
      throw Exception('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle accordingly
    throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When permissions are granted, get the position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  return position;
}
