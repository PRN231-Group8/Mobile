import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:explore_now/utils/constants/connection_strings.dart';
import 'package:http/io_client.dart';
import '../../../features/authentication/controllers/logout/logout_controller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PaymentService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    String? token = await secureStorage.read(key: 'access_token');
    if (token != null && JwtDecoder.isExpired(token)) {
      print('Token expired. Logging out.');
      LogoutController().logout();
      return null;
    }
    return token;
  }

  Future<String?> initiatePayment(String tourTripId) async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    final Uri url = Uri.parse('${TConnectionStrings.localhost}payments');

    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      print('No access token found or token expired');
      return null;
    }

    try {
      final response = await ioClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'tourTripId': tourTripId}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Received payment initiation response: $data");

        // Extract URL directly from 'result'
        final paymentUrl = data['result'] ?? '';
        if (paymentUrl.isEmpty) {
          print("Payment URL is empty in the API response.");
          return null;
        }

        print("Extracted payment URL: $paymentUrl");
        return paymentUrl;
      } else {
        print('Failed to initiate payment: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error initiating payment: $e');
      return null;
    } finally {
      ioClient.close();
    }
  }
}
