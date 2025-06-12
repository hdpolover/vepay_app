import 'package:flutter/material.dart';
import 'package:vepay_app/splashscreen.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vepay',
      builder: (context, child) =>
    ResponsiveBreakpoints.builder(child: child!, breakpoints: [
  const Breakpoint(start: 0, end: 959, name: MOBILE),        // Much larger mobile range
  const Breakpoint(start: 960, end: 1279, name: TABLET),     // Tablet range
  const Breakpoint(start: 1280, end: 1919, name: DESKTOP),
  const Breakpoint(start: 1920, end: double.infinity, name: '4K'),
]),
      home: const SplashScreen(),
    );
  }
}
