import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // طلب صلاحيات Firebase للإشعارات
    await _firebaseMessaging.requestPermission();

    // طباعة التوكن في debug mode
    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }

    // إعداد الإشعارات المحلية
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings);

    // الاستماع للإشعارات عند وصولها في foreground أو عند فتح التطبيق
    FirebaseMessaging.onMessage.listen(_handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
  }

  void _handleNotification(RemoteMessage message) {
    _showLocalNotification(
      message.notification?.title ?? 'إشعار جديد',
      message.notification?.body ?? '',
    );
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'volunteer_channel', // ID
      'إشعارات التطوع', // Name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      0, // ID
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
