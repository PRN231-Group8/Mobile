import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../features/tour_post/models/user_post_detail_model.dart';
import '../../../utils/constants/connection_strings.dart';

class ProductDetailService {
  var client = http.Client();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<UserPostDetailModel> fetchProductDetail(int productId) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    try {
      var response = await client.post(
        Uri.parse('${TConnectionStrings.deployment}mobile/food-package/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        if (kDebugMode) {
          print('Successfully retrieved product detail: $data');
        }
        return UserPostDetailModel.fromJson(data['data']);
      } else {
        if (kDebugMode) {
          print('Failed to retrieve product detail: ${response.body}');
        }
        throw Exception('Failed to retrieve product detail');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving product detail: $e');
      }
      throw Exception('Error retrieving product detail: $e');
    }
  }
}
