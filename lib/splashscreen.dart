import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            Image(
              width: MediaQuery.of(context).size.width * 0.8,
              image: const AssetImage('assets/logo_main.png'),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // Text(
            //   "v 0.0.1",
            //   style: Theme.of(context).textTheme.caption,
            // ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          ],
        ),
      ),
    );
  }
}
