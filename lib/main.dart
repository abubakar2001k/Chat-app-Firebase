
import 'package:chat_application/presentation/chat_screen/chat_vm/chat_screen_vm.dart';
import 'package:chat_application/presentation/home/home_screen.dart';
import 'package:chat_application/presentation/home/home_screen_vm.dart';
import 'package:chat_application/presentation/login/login_controller.dart';
import 'package:chat_application/presentation/login/login_page.dart';
import 'package:chat_application/presentation/signin/signup_controller.dart';
import 'package:chat_application/presentation/signin/singup_page.dart';
import 'package:chat_application/presentation/spalch_screen/spalch_vm.dart';
import 'package:chat_application/presentation/spalch_screen/splach_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'notifinotification_services/messeging.dart';
import 'notifinotification_services/notification_handler.dart';

final NotificationServices notificationServices = NotificationServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationHandler.initializeNotifications();

  NotificationHandler.handleForegroundNotifications();

  String? token = await notificationServices.getToken();
  print("FCM Token $token");
  debugPrint("FCM Token: $token");
  runApp(
    MultiProvider(
      providers: [
        // Ensure the provider is correctly initialized with a ChangeNotifier
        ChangeNotifierProvider(create: (_) => SplachController()),
        ChangeNotifierProvider(
          create: (_) => SignUpController(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginController(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background notification received: ${message.notification?.title}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // routes: {
    //   '/admin': (context) => const AdminPannel(),
    return MaterialApp(
      routes: {
        '/Homeduble': (context) => Homeduble(),
        '/signup': (context) => const SignUp(),
        '/login_page': (context) => LoginPage(),
        // '/home': (context)=> const HomeScreen(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      // navigatorObservers: <NavigatorObserver>[observer],
      home: SplachScreen(),
    );
  }
}
