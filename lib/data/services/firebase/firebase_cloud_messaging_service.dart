import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseCloudMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      if (kDebugMode) {
        print("Error obtaining FCM token: $e");
      }
      return null;
    }
  }
}