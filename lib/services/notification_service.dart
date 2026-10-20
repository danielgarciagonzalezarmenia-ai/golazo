import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inicializado = false;

  Future<void> init() async {
    if (_inicializado) return;
    tz.initializeTimeZones();

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: ios,
    );
    await _plugin.initialize(settings);
    _inicializado = true;
  }

  Future<void> programarRecordatorioDiario(int hora, int minuto) async {
    await cancelarNotificaciones();
    await _plugin.zonedSchedule(
      0,
      'GOLAZO',
      '¡Chispa se está quedando dormida! Practica 5 minutos ⚽',
      _nextDailyTime(hora, minuto),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'recordatorio',
          'Recordatorio diario',
          channelDescription: 'Recordatorio para practicar fútbol',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> programarRachaEnRiesgo(int hora, int minuto) async {
    await _plugin.zonedSchedule(
      1,
      'GOLAZO',
      '¡Tu racha está en riesgo! No dejes que Chispa se duerma 🔥',
      _nextDailyTime(hora, minuto),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'racha_riesgo',
          'Racha en riesgo',
          channelDescription: 'Aviso de racha en peligro',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelarNotificaciones() async {
    await _plugin.cancelAll();
  }

  tz.TZDateTime _nextDailyTime(int hora, int minuto) {
    final ahora = tz.TZDateTime.now(tz.local);
    var programmed = tz.TZDateTime(tz.local, ahora.year, ahora.month, ahora.day,
        hora, minuto);
    if (programmed.isBefore(ahora)) {
      programmed = programmed.add(const Duration(days: 1));
    }
    return programmed;
  }

  Future<bool> solicitarPermisos() async {
    return await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }
}
