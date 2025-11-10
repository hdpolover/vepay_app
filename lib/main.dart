import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/services/push_notif_service.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await PushNotifService().initNotif();

  final fcmToken = await FirebaseMessaging.instance.getToken();

  await SharedPreferences.getInstance().then((prefs) {
    prefs.setString('fcmToken', fcmToken!);
  });

  HttpOverrides.global = MyHttpOverrides();
  initializeDateFormatting();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
