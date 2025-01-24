import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationServices {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseMessaging _firebasemesseging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    try {
      NotificationSettings settings = await _firebasemesseging.requestPermission(
        alert: true,
        badge: true,
        criticalAlert: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission: ${settings.authorizationStatus}');
        String? token = await _firebasemesseging.getToken();
        print("FCM Token $token");
        debugPrint("FCM Token: $token");
        return token;
      } else {
        print('Permission Denied');
        return null;
      }
    } catch (e) {
      print("Errro in fetching $e");
      return null;
    }
  }
}
