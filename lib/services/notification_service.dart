import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pnbfoods/services/notifikasi_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static int _lastCount = 0;
  static Timer? _timer;

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
      macOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
    _lastCount = 0;
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;

    const androidDetails = AndroidNotificationDetails(
      'pnbfoods_notif',
      'PNBFoods Notifikasi',
      channelDescription: 'Notifikasi pesanan dan pembayaran',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  static void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _checkAndNotify();
    });
  }

  static void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> _checkAndNotify() async {
    try {
      final count = await fetchUnreadCount();
      if (count > _lastCount) {
        final newCount = count - _lastCount;
        await showNotification(
          title: 'Notifikasi Baru',
          body: newCount == 1
              ? 'Ada 1 notifikasi baru'
              : 'Ada $newCount notifikasi baru',
        );
      }
      _lastCount = count;
    } catch (_) {}
  }
}
