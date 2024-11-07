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

  Future<String?> initiatePayment(String tourTripId, int numberOfPassengers) async {
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
        body: jsonEncode({
          'tourTripId': tourTripId,
          'numberOfPassengers': numberOfPassengers
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Received payment initiation response: $data");

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
  Future<Map<String, dynamic>> sendPaymentCallback(Map<String, String> queryParams) async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);

    final Uri backendCallbackUrl = Uri.parse('${TConnectionStrings.localhost}payments/callback')
        .replace(queryParameters: queryParams);
    print("API GET URL: $backendCallbackUrl");

    try {
      final response = await ioClient.get(
        backendCallbackUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body);

      // Check the "isSucceed" field in the response
      if (response.statusCode == 200 && data['isSucceed'] == true) {
        print('Giao dịch hoàn thành.');
        return {'success': true, 'message': data['result']['message'] ?? 'Giao dịch thành công.'};
      } else {
        print('Không thể hoàn thành giao dịch. Lý do: ${data['message'] ?? 'Unknown error'}');
        return {'success': false, 'message': data['result']['message'] ?? 'Không thể hoàn thành giao dịch.'};
      }
    } catch (e) {
      print('Lỗi khi gọi BE callback API: $e');
      return {'success': false, 'message': 'Lỗi kết nối với hệ thống.'};
    } finally {
      ioClient.close();
    }
  }
}
