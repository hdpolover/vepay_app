import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vepay_app/splashscreen.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Configure system UI for edge-to-edge display
    _configureSystemUI();
  }

  void _configureSystemUI() {
    // Set transparent system bars for edge-to-edge display
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    // Enable edge-to-edge mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vepay',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: SafeArea(
          // Use SafeArea to handle system insets properly
          top: true,
          bottom: true,
          left: false,
          right: false,
          child: child!,
        ),
        breakpoints: [
          const Breakpoint(start: 0, end: 480, name: MOBILE),
          const Breakpoint(start: 481, end: 1024, name: TABLET),
          const Breakpoint(start: 1025, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const SplashScreen(),
    );
  }
}
