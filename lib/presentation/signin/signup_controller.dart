
import 'package:chat_application/data/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../notifinotification_services/messeging.dart';

class SignUpController extends ChangeNotifier {


  bool _isObscure = true;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool get isObscure => _isObscure;

  void setLoding(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> visiblity() async {
    _isObscure = ! _isObscure;
    notifyListeners();
  }

  final NotificationServices notificationServices = NotificationServices();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    userIdController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp(BuildContext context) async {
    setLoding(true);
    final name = nameController.text.trim();
    final email = emailController.text.toLowerCase().trim();
    final password = passwordController.text.trim();
    final userid = userIdController.text.trim();
    final conformPassword = conformPasswordController.text.trim();

    // Validate password confirmation
    if (password != conformPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    // Validate all fields are filled
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;


      String? token = await notificationServices.getToken();
      print("FCM Token $token");
      debugPrint("FCM Token: $token");
      if(token ==null ) {
        print("Error in Taking Fcm Token");
        return;
      }
      // return;
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if(fcmToken ==null ) {
        print("Errro in Taking Fcm Token");
        return;
      }
      // Prepare data to save in Realtime Database
      UserModel datsBaseHelper = UserModel(
        name: name,
        email: email,
        userId: userId,
        password: password,
        fcmToken: token,
      );

      // Save user data in Realtime Database
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      await databaseReference
          .child("users")
          .child(userId)
          .set(datsBaseHelper.toJson());

      // Clear fields after successful signup
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      conformPasswordController.clear();
      userIdController.clear();

      notifyListeners();
      Navigator.pushNamed(context, '/login_page');
      print("User signed up and data saved successfully!");
    } catch (e) {
      // Handle errors and show feedback
      print("Sign-Up Failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-Up Failed: ${e.toString()}")),
      );
    } finally {
      setLoding(false);
    }
  }
}

