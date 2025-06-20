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
  const Breakpoint(start: 0, end: 480, name: MOBILE),        // Much larger mobile range
  const Breakpoint(start: 481, end: 1024, name: TABLET),     // Tablet range
  const Breakpoint(start: 1025, end: 1920, name: DESKTOP),
  const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
]),
      home: const SplashScreen(),
    );
  }
}
