import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants/connection_strings.dart';

class UserProfileService {
  var client = http.Client();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<String?> getUserEmail() async {
    return await secureStorage.read(key: 'user_email');
  }

  Future<String?> getUserId() async {
    return await secureStorage.read(key: 'user_id');
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    String? accessToken = await getAccessToken();
    String? userEmail = await getUserEmail();

    try {
      var response = await client.get(
        Uri.parse('${TConnectionStrings.deployment}users/$userEmail/email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (kDebugMode) {
          print('Successfully retrieved user information: $data');
        }
        return {"success": true, "data": data};
      } else {
        if (kDebugMode) {
          print('Failed to retrieve user information: ${response.body}');
        }
        return {
          "success": false,
          "message": 'Failed to retrieve user information',
        };
      }
    } catch (e) {
      return {
        "userInformation": false,
        "message": 'Error retrieving user information: $e'
      };
    }
  }

  Future<Map<String, Object>> updateUserProfilePicture(XFile image) async {
    String? accessToken = await getAccessToken();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${TConnectionStrings.deployment}users/image'),
      );
      request.headers['Authorization'] = 'Bearer $accessToken';

      var file = await http.MultipartFile.fromPath('file', image.path);
      request.files.add(file);

      var response = await request.send().timeout(const Duration(seconds: 10));
      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Successfully updated profile picture');
        }
        return {
          "success": true,
          "message": "Profile picture updated successfully"
        };
      } else {
        if (response.statusCode == 500) {
          return {
            "success": false,
            "message":
                'Maximum upload size exceeded. Please try with a smaller image.'
          };
        } else {
          if (kDebugMode) {
            print('Failed to update profile picture: ${responseData.body}');
          }
          return {
            "success": false,
            "message": 'Failed to update profile picture',
          };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile picture: $e');
      }
      return {
        "success": false,
        "message": 'Error updating profile picture: $e'
      };
    }
  }

  Future<Map<String, Object>> updateUserProfile(
      Map<String, dynamic> updatedFields) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      return {"success": false, "message": "No access token found"};
    }

    var userProfile = await getUserProfile();
    if (userProfile["success"] != true) {
      return {"success": false, "message": "Failed to get user profile"};
    }

    String? userId = await getUserId();
    Map<String, dynamic> userData = userProfile["data"];

    userData.addAll(updatedFields);

    if (!updatedFields.containsKey("dob") ||
        updatedFields["dob"] == null ||
        updatedFields["dob"].isEmpty) {
      userData["dob"] = DateTime.now().toUtc().toIso8601String();
      userData["gender"] = "Male";
    } else {
      try {
        DateTime dob = DateTime.parse(updatedFields["dob"]);
        userData["dob"] = dob.toIso8601String();

        if (!updatedFields.containsKey("gender") ||
            updatedFields["gender"] == null ||
            updatedFields["gender"].isEmpty) {
          userData["gender"] = "Male";
        } else {
          userData["gender"] = updatedFields["gender"];
        }
      } catch (e) {
        if (kDebugMode) {
          print("Invalid date format for dob: ${updatedFields["dob"]}");
        }
        return {"success": false, "message": "Invalid date format for dob"};
      }
    }

    try {
      var response = await client
          .put(
            Uri.parse('${TConnectionStrings.deployment}users/profile/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(userData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Successfully updated user profile');
        }
        return {
          "success": true,
          "message": "User profile updated successfully"
        };
      } else {
        if (kDebugMode) {
          print('Failed to update user profile: ${response.body}');
        }
        return {
          "success": false,
          "message": 'Failed to update user profile',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
      return {"success": false, "message": 'Error updating user profile: $e'};
    }
  }
}
