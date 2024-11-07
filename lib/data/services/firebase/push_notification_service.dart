import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": dotenv.env['SERVICE_ACCOUNT_TYPE'],
      "project_id": dotenv.env['PROJECT_ID'],
      "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
      "private_key": dotenv.env['PRIVATE_KEY']?.replaceAll(r'\n', '\n') ?? '',
      "client_email": dotenv.env['CLIENT_EMAIL'],
      "client_id": dotenv.env['CLIENT_ID'],
      "auth_uri": dotenv.env['AUTH_URI'],
      "token_uri": dotenv.env['TOKEN_URI'],
      "auth_provider_x509_cert_url": dotenv.env['AUTH_PROVIDER_CERT_URL'],
      "client_x509_cert_url": dotenv.env['CLIENT_CERT_URL'],
      "universe_domain": dotenv.env['UNIVERSE_DOMAIN']
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/firebase.database",
          "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedDriver(String deviceToken,
      BuildContext context, String message, String userName) async {
    final String serverAccessToken = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/explore-now-travel/messages:send';
    final Map<String, dynamic> chatNotification = {
      'message': {
        'token': deviceToken,
        'notification': {'title': userName, 'body': message},
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessToken'
      },
      body: jsonEncode(chatNotification),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Notification sent successfully");
      }
    } else {
      if (kDebugMode) {
        print(
            "FCM message failed to send with status code: ${response.statusCode}");
      }
    }
  }
}
