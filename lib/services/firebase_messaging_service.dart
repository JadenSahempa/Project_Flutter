import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'local_notifications_service.dart';

/// Handler FCM ketika aplikasi dalam background atau terminated.
/// Harus berada di top-level function.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notif = message.notification;

  // if (kDebugMode) {
  //   print('[FCM BG] Message ID: ${message.messageId}');
  // }

  if (notif != null) {
    await LocalNotificationsService.showNotification(
      title: notif.title ?? 'Notifikasi',
      body: notif.body ?? 'Ada pesan baru',
    );
  }
}

class FirebaseMessagingService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Inisialisasi FCM: izin notifikasi, token, dan handler pesan.
  static Future<void> initialize() async {
    // Meminta izin notifikasi (khusus Android 13+ & iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // if (kDebugMode) {
    //   print('[FCM] Permission: ${settings.authorizationStatus}');
    // }

    // Mendapatkan FCM token device
    final token = await _fcm.getToken();
    // if (kDebugMode) {
    //   print('[FCM] Token: $token');
    // }

    // Handler pesan saat aplikasi foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notif = message.notification;

      // if (kDebugMode) {
      //   print('[FCM FG] Message ID: ${message.messageId}');
      //   print('[FCM FG] Data: ${message.data}');
      // }

      // Tampilkan notifikasi lokal saat aplikasi foreground
      if (notif != null) {
        await LocalNotificationsService.showNotification(
          title: notif.title ?? 'Notifikasi',
          body: notif.body ?? 'Ada pesan baru',
        );
      }
    });

    // Handler ketika notifikasi diketuk dari background
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (kDebugMode) {
    //     print('[FCM OPEN] Message ID: ${message.messageId}');
    //   }

    //   // Jika ingin navigate ke halaman tertentu, lakukan di sini
    // });

    // Handler pesan ketika aplikasi dibuka dari kondisi terminated
    // final initialMessage = await _fcm.getInitialMessage();
    // if (initialMessage != null && kDebugMode) {
    //   print('[FCM INIT] Opened from terminated: ${initialMessage.messageId}');
    // }
  }
}
