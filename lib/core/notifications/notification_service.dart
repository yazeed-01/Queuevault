import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../router/app_router.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Set when the app was cold-started via a notification tap.
  // Consumed by navigatePendingIfAny() once the router is ready.
  static int? _pendingItemId;

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: _onTapBackground,
    );
    _initialized = true;

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Cold-start: store the item ID — the router doesn't exist yet.
    // Navigation happens in navigatePendingIfAny() after the router mounts.
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails!.notificationResponse?.payload;
      _pendingItemId = int.tryParse(payload ?? '');
    }
  }

  /// Call this after the GoRouter has been created and mounted.
  static void navigatePendingIfAny() {
    final id = _pendingItemId;
    if (id == null) return;
    _pendingItemId = null;
    appRouter.push('/item/$id');
  }

  static void _onTap(NotificationResponse response) {
    _navigateToItem(response.payload);
  }

  static void _navigateToItem(String? payload) {
    if (payload == null) return;
    final id = int.tryParse(payload);
    if (id == null) return;
    appRouter.push('/item/$id');
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? posterUrl,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'queuevault_reminders',
      'Reminders',
      channelDescription: 'QueueVault item reminders',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: id.toString(),
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  Future<void> cancelAll() => _plugin.cancelAll();
}

@pragma('vm:entry-point')
void _onTapBackground(NotificationResponse response) {
  // Background isolate — navigation happens when app resumes via getNotificationAppLaunchDetails
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());
