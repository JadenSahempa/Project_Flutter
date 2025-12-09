import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// import entity Todo kamu
import 'package:luar_sekolah_lms/features/todo_module/domain/entities/todo_entity.dart';

class LocalNotificationsService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _tzInitialized = false;

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'Used for general app notifications',
        importance: Importance.high,
      );

  static const AndroidNotificationChannel _todoChannel =
      AndroidNotificationChannel(
        'todo_reminder_channel',
        'Todo Reminders',
        description: 'Reminder untuk tugas / todo yang dijadwalkan',
        importance: Importance.high,
      );

  static Future<void> _ensureTimezoneInitialized() async {
    if (_tzInitialized) return;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Makassar')); // boleh ganti
    _tzInitialized = true;
  }

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        // handle ketika notif di-tap
      },
    );

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.createNotificationChannel(_defaultChannel);
    await androidImpl?.createNotificationChannel(_todoChannel);
  }

  // ⬇️ ini tetap: untuk notifikasi biasa
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _defaultChannel.id,
      _defaultChannel.name,
      channelDescription: _defaultChannel.description,
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _plugin.show(id, title, body, notificationDetails);
  }

  // 🔔 dipanggil dari TodoController
  static Future<void> scheduleTodoReminder(TodoEntity todo) async {
    if (todo.reminderAt == null) return;

    await _ensureTimezoneInitialized();

    final notifId = todo.id.hashCode & 0x7fffffff;
    final scheduled = tz.TZDateTime.from(todo.reminderAt!, tz.local);

    if (scheduled.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      _todoChannel.id,
      _todoChannel.name,
      channelDescription: _todoChannel.description,
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        notifId,
        'Reminder: ${todo.title}',
        todo.description,
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: todo.id,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      // optional: log aja, jangan sampai bikin user lihat error jelek
      debugPrint('Gagal schedule reminder: $e');
    }
  }

  static Future<void> cancelTodoReminder(String todoId) async {
    final notifId = todoId.hashCode & 0x7fffffff;
    await _plugin.cancel(notifId);
  }
}
