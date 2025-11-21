import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/utils/shared_helper.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:luar_sekolah_lms/week_9/presentation/bindings/auth_bindings.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/local_notifications_service.dart';
import 'services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences
  await StorageHelper.init();

  // Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // register semua dependency auth
  AuthBindings().dependencies();

  // 🟢 Init local notifications
  await LocalNotificationsService.initialize();

  // 🟢 Daftarkan handler background FCM
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 🟢 Init FCM (minta permission, onMessage, dll)
  await FirebaseMessagingService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // final loggedIn = StorageHelper.instance.isLoggedIn();
    final user = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luarsekolah LMS',
      theme: ThemeData(primarySwatch: Colors.purple),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: user != null ? RouteNames.shell : RouteNames.login,
    );
  }
}
