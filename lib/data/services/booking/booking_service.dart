import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../../features/personalization/models/booking_history.dart';
import '../../../utils/constants/connection_strings.dart';

class BookingHistoryService {
  final client = http.Client();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<List<TourPackageHistory>> fetchBookingHistory() async {
    String? accessToken = await getAccessToken();
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);

    try {
      final response = await ioClient.get(
        Uri.parse('${TConnectionStrings.deployment}payments/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((item) => TourPackageHistory.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load booking history');
      }
    } catch (e) {
      throw Exception('Failed to load booking history');
    } finally {
      ioClient.close();
    }
  }
}
