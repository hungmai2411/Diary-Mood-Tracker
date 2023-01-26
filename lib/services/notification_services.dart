import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsServices {
  static FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    int? hour,
    int? minute,
    required DateTime scheduledDate,
  }) async {
    await notifications.zonedSchedule(
      id,
      title,
      body,
      scheduleDaily(Time(hour!, minute!)),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );
    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        onNotifications.add(details.payload);
      },
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getAvailableTimezones();
      int a = 0;

      for (var l in locationName) {
        if (l == 'Asia/Ho_Chi_Minh') {
          break;
        }
        ++a;
      }
      print(a);
      tz.setLocalLocation(tz.getLocation(locationName[246]));
    }
  }

  static tz.TZDateTime scheduleDaily(Time time) {
    print(tz.local.name);
    final now = tz.TZDateTime.now(tz.local);
    print(now);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    print(scheduleDate);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }
}
