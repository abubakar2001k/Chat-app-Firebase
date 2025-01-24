import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class BearerToken {
  Future<String> generateBearerToken() async {
    final serviceAccountJson = "YOUR_SERVICE_JSON";

    final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final authClient = await clientViaServiceAccount(credentials, scopes);
    final accessToken = authClient.credentials.accessToken.data;

    authClient.close();

    return accessToken;
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    required String fcmToken,
  }) async {
    try {
      // Get the Bearer Token for Firebase Cloud Messaging
      final bearerToken = await generateBearerToken();

      // Send the FCM notification
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/chatapplication-18c35/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode({
          'message': {
            'token': fcmToken,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'type': 'chat',
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
