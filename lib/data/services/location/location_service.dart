import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:explore_now/features/home_screens/screens/home/models/location_model.dart';
import 'package:explore_now/utils/constants/connection_strings.dart';
import 'package:http/io_client.dart';

class LocationService {
  Future<List<Location>> fetchLocations() async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Bypass SSL verification

    final ioClient = IOClient(httpClient);
    final response = await ioClient
        .get(Uri.parse('${TConnectionStrings.localhost}locations'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'] is List) {
        List<Location> locations = (data['results'] as List)
            .map((item) => Location.fromJson(item))
            .toList();
        locations.shuffle(Random());
        return locations.take(4).toList();
      } else {
        throw Exception('Invalid data format or no results found');
      }
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<List<Location>> fetchAllLocations() async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            true; // Bypass SSL verification

    final ioClient = IOClient(httpClient);
    final response = await ioClient
        .get(Uri.parse('${TConnectionStrings.localhost}locations'));
    print('API Response: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'] is List) {
        List<Location> locations = (data['results'] as List)
            .map((item) => Location.fromJson(item))
            .toList();
        return locations.toList();
      } else {
        throw Exception('Invalid data format or no results found');
      }
    } else {
      throw Exception('Failed to load locations');
    }
  }
}
