import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/screens/auth/intro.dart';
import 'package:vepay_app/screens/auth/login.dart';
import 'package:vepay_app/screens/dashboard.dart';
import 'package:vepay_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  @override
  void initState() {
    _startDelay();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> _checkUserLoginStatus() async {
    WidgetsFlutterBinding.ensureInitialized();
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loginStatus") ?? false;
  }

  _goNext() async {
    if (await _checkUserLoginStatus()) {
      var prefs = await SharedPreferences.getInstance();

      String? email = prefs.getString("email");
      String? password = prefs.getString("password");

      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      try {
        MemberModel? res = await AuthService().login(data);

        CommonMethods().saveUserLoginsDetails(
          res.userId!,
          res.name!,
          res.email!,
          password!,
          true,
        );

        _goToPage(Dashboard(member: res));
      } catch (e) {
        buildError(e);
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => Intro(),
        ),
      );
    }
  }

  buildError(var e) {
    CommonDialog.buildWrongWithAuth(context, false, e.toString());
  }

  _goToPage(Widget name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
