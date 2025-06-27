import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_latest;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const _prefsKey = 'notification_id_counter';
  bool _isInitialized = false;
  int _notificationIdCounter = 0;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Timezone setup
    tz_latest.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Android
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);

    final prefs = await SharedPreferences.getInstance();
    _notificationIdCounter = prefs.getInt(_prefsKey) ?? 0;

    _isInitialized = true;
  }

  NotificationDetails notificationsDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({int? id, String? title, String? body}) async {
    final uniqueId = id ?? await _generateNotificationId();
    await notificationsPlugin.show(
      uniqueId,
      title,
      body,
      notificationsDetails(),
    );
  }

  Future<void> scheduleNotification({
    int? id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final uniqueId = id ?? await _generateNotificationId();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      uniqueId,
      title,
      body,
      scheduledDate,
      notificationsDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotificationById(int id) async {
    await notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    return await notificationsPlugin.pendingNotificationRequests();
  }

  Future<int> _generateNotificationId() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationIdCounter++;
    await prefs.setInt(_prefsKey, _notificationIdCounter);
    return _notificationIdCounter;
  }
}
