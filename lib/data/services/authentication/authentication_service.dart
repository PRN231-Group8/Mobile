import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../features/authentication/controllers/logout/logout_controller.dart';
import '../../../utils/constants/connection_strings.dart';

class AuthenticationService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> saveTokenExpiration(DateTime expirationTime) async {
    final box = GetStorage();
    box.write('token_expiration', expirationTime.toIso8601String());
  }

  DateTime? getTokenExpiration() {
    final box = GetStorage();
    String? expirationString = box.read('token_expiration');
    if (expirationString != null) {
      return DateTime.parse(expirationString);
    }
    return null;
  }

  Future<Map<String, dynamic>> handleSignUp({
    required String email,
    required String firstName,
    required String lastName,
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    var userRegisterInformation = {
      "email": email.trim(),
      "userName": userName.trim(),
      "password": password.trim(),
      "lastName": lastName.trim(),
      "firstName": firstName.trim(),
      "confirmPassword": confirmPassword.trim(),
    };

    try {
      var response = await _client
          .post(
            Uri.parse('${TConnectionStrings.deployment}auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userRegisterInformation),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {"success": true, "data": data};
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        if (kDebugMode) {
          print("Validation error data: $errorData");
        }
        return {
          "success": false,
          "message": 'Đã xảy ra lỗi xác thực',
        };
      } else {
        return {
          "success": false,
          "message": 'Đã xảy ra sự cố không xác định, vui lòng thử lại sau'
        };
      }
    } catch (e) {
      return {"success": false, "message": 'Đã xảy ra sự cố: $e'};
    }
  }

  Future<dynamic> handleSignIn({
    required String userName,
    required String password,
  }) async {
    var userSignInInformation = {
      "userName": userName.trim().toLowerCase(),
      "password": password.trim(),
    };

    try {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final ioClient = IOClient(httpClient);
      var response = await ioClient
          .post(
            Uri.parse('${TConnectionStrings.localhost}auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userSignInInformation),
          )
          .timeout(const Duration(seconds: 20));

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await secureStorage.write(
            key: 'access_token', value: responseData['token']);
        final accessToken = responseData['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        int? expirationTime = decodedToken['exp'];
        await secureStorage.write(
            key: 'user_email', value: responseData['email']);

        if (expirationTime != null) {
          await secureStorage.write(
              key: 'token_expiration', value: expirationTime.toString());
          startTokenExpirationCheck();
        }
        if (kDebugMode) {
          print('data: ${response.body}');
        }
        return {"success": true, "data": responseData};
      } else if (response.statusCode == 400) {
        var errorDetails = responseData['errors'] ?? {};

        if (errorDetails.containsKey('Password')) {
          return {
            "success": false,
            "message": errorDetails['Password'].join(", ")
          };
        }
        if (errorDetails.containsKey('UserName')) {
          return {
            "success": false,
            "message": errorDetails['UserName'].join(", ")
          };
        }

        return {
          "success": false,
          "message": responseData['title'] ?? 'Validation error occurred'
        };
      } else if (response.statusCode == 400) {
        return {
          "success": false,
          "message": 'Username or password is incorrect'
        };
      } else {
        return {"success": false, "message": 'An unknown error occurred'};
      }
    } catch (e) {
      return {"success": false, "message": 'An error occurred: $e'};
    }
  }

  void startTokenExpirationCheck() {
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      String? expirationString =
          await secureStorage.read(key: 'token_expiration');
      if (expirationString != null) {
        int expirationTime = int.parse(expirationString);
        int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        if (currentTime >= expirationTime) {
          timer.cancel();
          LogoutController().logout();
        }
      }
    });
  }
}
