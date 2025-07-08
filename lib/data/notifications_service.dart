import 'package:diabary/core/routes/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Inicializa as zonas de tempo
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;

        if (payload != null && payload.isNotEmpty) {
          appRouter.pushNamed(
            AppRoutes.alarm.name,
            pathParameters: {'medId': payload},
          );
        }
      },
    );

    if (await Permission.notification.isDenied ||
        await Permission.notification.isPermanentlyDenied) {
      await Permission.notification.request();
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleWeeklyNotifications({
    required String medId,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'medication_channel',
      'Lembretes de Medicação',
      channelDescription: 'Notificações recorrentes para tomar medicação',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    for (final weekday in weekdays) {
      final scheduledDate = _nextInstanceOfWeekdayTime(weekday, hour, minute);
      final id = scheduledDate.millisecondsSinceEpoch.remainder(100000);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: medId,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    // Programe para o horário desejado no dia de hoje
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Se o horário de hoje já passou, programe para o mesmo dia da próxima semana
    if (scheduled.isBefore(now)) {
      // Calcule a diferença entre o weekday solicitado e o dia da semana atual
      int daysToAdd = (weekday - now.weekday) % 7;
      if (daysToAdd <= 0) {
        // Se o weekday selecionado já passou, adiciona 7 dias para a próxima semana
        daysToAdd += 7;
      }
      scheduled = scheduled.add(Duration(days: daysToAdd));
    }

    // Caso o horário de hoje ainda não tenha passado, então agendamos para o dia da semana correto nesta semana
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> loadNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> _cancelNotificationsByTitle(String title) async {
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (final p in pending) {
      if (p.title == title) {
        await flutterLocalNotificationsPlugin.cancel(p.id);
      }
    }
  }

  Future<void> rescheduleNotification({
    required String oldTitle,
    required String newTitle,
    required String body,
    required int hour,
    required int minute,
    required List<int> weekdays,
    required String medId,
  }) async {
    await _cancelNotificationsByTitle(oldTitle);

    await scheduleWeeklyNotifications(
      title: newTitle,
      body: body,
      hour: hour,
      minute: minute,
      weekdays: weekdays,
      medId: medId,
    );
  }
}
