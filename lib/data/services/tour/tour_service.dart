import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:explore_now/utils/constants/connection_strings.dart';
import 'package:http/io_client.dart';

import '../../../features/home_screens/screens/home/models/tour_model.dart';

class TourService {
  Future<List<Tour>> fetch4Tours() async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    final response =
        await ioClient.get(Uri.parse('${TConnectionStrings.localhost}tours'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tours =
          (data['results'] as List).map((e) => Tour.fromJson(e)).toList();
      tours.shuffle(Random());
      return tours.take(4).toList();
    } else {
      throw Exception('Failed to load tours');
    }
  }

  Future<List<Tour>> fetchAllTours() async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    final response =
        await ioClient.get(Uri.parse('${TConnectionStrings.localhost}tours'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tours =
          (data['results'] as List).map((e) => Tour.fromJson(e)).toList();
      return tours;
    } else {
      throw Exception('Failed to load tours');
    }
  }

  Future<Tour?> fetchTourById(String id) async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    final response = await ioClient
        .get(Uri.parse('${TConnectionStrings.localhost}tours/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] != null) {
        return Tour.fromJson(data['result']);
      } else if (data['results'] != null) {
        List<dynamic> results = data['results'];
        for (var item in results) {
          if (item['id'] == id) {
            return Tour.fromJson(item);
          }
        }
        throw Exception('Tour with id $id not found in results');
      } else {
        throw Exception('Unexpected response structure');
      }
    } else {
      throw Exception('Failed to load tour details');
    }
  }
}
