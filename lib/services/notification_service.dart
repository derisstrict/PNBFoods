import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pnbfoods/services/notifikasi_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static int _lastSeenId = 0;
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
    _lastSeenId = 0;

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
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
      icon: 'ic_notification',
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

  static void startPolling({Duration interval = const Duration(seconds: 5)}) {
    _timer?.cancel();
    _initLastSeenId().then((_) {
      _timer = Timer.periodic(interval, (_) async {
        await _checkAndNotify();
      });
    });
  }

  static Future<void> _initLastSeenId() async {
    try {
      final notifikasi = await fetchNotifikasi();
      if (notifikasi.isNotEmpty) {
        _lastSeenId = notifikasi.map((n) => n.id).reduce(
          (a, b) => a > b ? a : b,
        );
      }
    } catch (_) {}
  }

  static void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> _checkAndNotify() async {
    try {
      final notifikasi = await fetchNotifikasiRecent(_lastSeenId);
      for (final n in notifikasi) {
        await showNotification(
          title: n.judul,
          body: n.isi,
        );
        if (n.id > _lastSeenId) {
          _lastSeenId = n.id;
        }
      }
    } catch (_) {}
  }
}
