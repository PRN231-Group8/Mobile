import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../../../features/tour_post/models/user_post_model.dart';
import '../../../utils/constants/connection_strings.dart';

class TourPostService {
  var client = http.Client();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<List<PostModel>> fetchPostData() async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    try {
      var response = await client.get(
        Uri.parse('${TConnectionStrings.deployment}posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (kDebugMode) {
          print('Successfully retrieved product data: $data');
        }
        final List<dynamic> postsJson = data['result'];
        final List<PostModel> approvedPosts = postsJson
            .where((item) => item['status'] == 'Approved')
            .map((item) => PostModel.fromJson(item))
            .toList();

        return approvedPosts;
      } else {
        if (kDebugMode) {
          print('Failed to retrieve product data: ${response.body}');
        }
        throw Exception('Failed to retrieve product data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving product data: $e');
      }
      throw Exception('Error retrieving product data: $e');
    }
  }

  Future<bool> deletePost(String postId) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    try {
      final response = await client.delete(
        Uri.parse('${TConnectionStrings.deployment}posts/$postId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting post: $e");
      }
      return false;
    }
  }

  Future<bool> addComment(String content, String postId) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }
    try {
      final response = await http.post(
        Uri.parse('${TConnectionStrings.deployment}comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'content': content,
          'postId': postId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createPost(String content, List<File> photoFiles) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${TConnectionStrings.deployment}posts'),
      );

      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['accept'] = '*/*';
      request.fields['Content'] = content;

      for (var photoFile in photoFiles) {
        String fileExtension = extension(photoFile.path).toLowerCase();
        String contentType;

        switch (fileExtension) {
          case '.jpg':
          case '.jpeg':
            contentType = 'image/jpeg';
            break;
          case '.png':
            contentType = 'image/png';
            break;
          default:
            throw Exception('Unsupported file type: $fileExtension');
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'Photos',
            photoFile.path,
            filename: basename(photoFile.path),
            contentType: MediaType.parse(contentType),
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Post created successfully');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to create post: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating post: $e');
      }
      return false;
    }
  }
}
