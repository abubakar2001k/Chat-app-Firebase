import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class BearerToken {
  Future<String> generateBearerToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "chatapplication-18c35",
      "private_key_id": "d645bd9b3c6b01f50f7b32918296a39f47771d5d",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQChMF+EZK1gJM6m\nkI2nTtWSmsB3B49qhjpJyyXvylMuZ1nXN3UqhnzAZdQsM0M2lH+qbhi6gS4IO1wg\nxlJOn04HNezkuUSX6zcMG6xb4McI6CNSD4+lo2riAXSX6fmdEBwP/OUNlRD2yDSW\nxxCyDyA9jtHajtnVm9m4NiITPJnIdXLGSFHpYg9XSnN1EKlTaletzvxH+izhPPK7\nXfcP2TXJ0hOE/z39A1eFWyAJX8791/BKDxo1qcq4YCHnKSUJhAhUQ5lqh+4J0Tdz\n/rUZI8YZa0y9IegQa64TZItO3nxZUfOV+jA+H1R+DzRd3c6MueEpiWiqjADtL7Oh\noJnYl/QxAgMBAAECgf9jO6nnkn4/jRQWlzJIqM/zIYe7v9EbKOeu5nzEfdrChqit\n8QZrgmrq8nBc2x0AomC2RnFoNdRmXPpVcxguLwTqi4L74ihzHpZqbd7+nAiXWH07\ngo5SJaPM36MtTcN5CPc9yy4jM9JDG54Z9ROM4KMImBRkaULSWXsACCjnjuIIoMs4\nyA1yxqR/2JjMzuY+8UlMlOipyXjg3QC/ebuwyS0hnKYACA4JzuFm4Wl/wedHTlrx\nxdW2SpigztHt/K9sRwlR33VT2XThg+htpdwU88qOYW09Ll1J4aikFDDkhtIwl5l/\nNBaOxRmTotdruNl54LLLjvc0D7Q7/ACZ6YhUTqECgYEA1qLO+jcysz9prtG5yPPb\n9E54d9+84vdBQwfNxlQN7LOwg0SYkfFGCzyglWrMaATO6w4SyBZvcYBcnqcv9T3w\nX+HNesDZ2xYNgg9kD/4oCxwDCOvkrsc7eW+9RJL7Bl6xsllC2saksJghqmkU094H\nw5dIyfyFlUh5m8/c/kc0rlECgYEAwEC5kLcq2MCwy7XND3VefG11691P/EDQMQ95\nWFx4OKxaTH2ynxLDjhEClaTU3zc7OYzbwMUKz2Iy573EAa6aQVBUKpZdcgpzAS9R\nHc/b9S5U5wC+oR9eYZwx4zBZ0xf4jBUA1OyPMiPgvrAn3hqmDkP4He7aRjW25J2e\ntTLUD+ECgYEAgG1eh11r2tFAvTgEgHdZzy786k1Xyj7EMAWFXPyCcHV8Uq9C02CY\n1rRqKb2DnWHzJbaACnVSLYnu4YeMLKPpJpYHy0GFmY/yeTYYW3FqKGuUbUwow2O2\n9IylpViFF2Sl0t+SHzHo7Tm6OysxKSybXK8zAJk2nQKGsXKI+yVEImECgYEAp/dk\nqOT/EES5siDyObFHjdpsjlfbS/6sZlCoqeSQPKOIeQ/RAV35cKO36FoMicDNg6hn\nTnJY0XtwEjwfhYCw0KOIBXU9yycJ910Jt8wk1n9WOkTSSB8J7Kn0hBN4Rw/IXUr0\nYRMUwK/L6Y4qJsiNkCUeH7jRB0pisjZrtM/lqsECgYAV/oZxhrL8r8ynpEfAw+vu\nEwy40yS46Po5n7B/CeOMjoOhpZDVhWxzwhSn/LdaHqXekkA22mh0Tq2ORBf/EyoB\nhGnm/C5m5fBopkV16tkHHFTD/HncaQ96SgX0aRuSCjN9hmweHvXcA+gbyjE5/P4d\nc/ImE0OnKbsHk0WrzA7mhw==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fzd3d@chatapplication-18c35.iam.gserviceaccount.com",
      "client_id": "112478788923176823696",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fzd3d%40chatapplication-18c35.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

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
