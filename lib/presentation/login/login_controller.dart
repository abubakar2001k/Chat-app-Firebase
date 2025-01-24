
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../notifinotification_services/messeging.dart';


class LoginController extends ChangeNotifier {

  bool _isObscure = true;
  bool _isLoding = false;

  bool get isLoading => _isLoding;
  bool get isObscure => _isObscure;

  void setLoading(bool value) {
    _isLoding = value;
    notifyListeners();
  }


  Future<void> visiblity() async {
    _isObscure = !_isObscure;
    notifyListeners();
  }


  final NotificationServices notificationServices = NotificationServices();

  bool isLoggedIn = false; // Track loading state

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Sign in with email and password
  Future<void> signInWithEmailPassword(BuildContext context) async {
    setLoading(true);

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // final String userId = userCredential.user?.uid ?? '';
      // String userId = userCredential.user!.uid;
      // String userId =  user.uid;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('userEmail', userCredential.user?.email ?? '');
      await sharedPreferences.setString('userId', userCredential.user?.uid ?? '');
      await sharedPreferences.setBool('isLoggedIn', true);

      final User? user = _auth.currentUser;
      final String userId = user!.uid;

      String? token = await notificationServices.getToken();
      print("Fcm token In Login $token");
      if (token == null) {
        print("Error in Taking Fcm Token");
        return;
      }

      // Update the FCM token in Realtime Database
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      await databaseReference.child("users").child(userId).update({
        'fcmToken': token,
      });
      // DatabaseReference databaseReference

      print("FCM token updated successfully!");
      print('User signed in: ${userCredential.user?.email}');
      Navigator.pushNamed(context, '/Homeduble');
      emailController.clear();
      passwordController.clear();
      notifyListeners();
      // Navigate to another screen if needed
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally{
      setLoading(false);
    }
  }
}
