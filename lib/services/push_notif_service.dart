import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotifService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("bg message received");
    // print all message data
    for (var key in message.data.keys) {
      print('$key: ${message.data[key]}');
    }
  }

  handleMessage(RemoteMessage? message) {
    if (message == null) return;

    print("handle message received");
  }

  Future initPushNotif() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notif = message.notification;

      print("listen message received");

      if (notif == null) return;

      _flutterLocalNotifications.show(
          notif.hashCode,
          notif.title,
          notif.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/launcher_icon',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future iniLocalNotif() async {
    const IOS = DarwinInitializationSettings();

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');

    const settings = InitializationSettings(android: android, iOS: IOS);

    await _flutterLocalNotifications.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: (message) {
      print("background");

      onNotifSelect(message);
    }, onDidReceiveNotificationResponse: (message) {
      print("foreground");

      onNotifSelect(message);
    });

    await _flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  onNotifSelect(NotificationResponse response) {
    print("notif selected");
    print(jsonEncode(response.payload));
  }

  Future<void> initNotif() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.getToken().then((value) async {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("fcmToken", value!);

      print('FCM Token: $value');
    });

    initPushNotif();
    //iniLocalNotif();
  }
}
