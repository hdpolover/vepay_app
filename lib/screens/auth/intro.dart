import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/screens/auth/login.dart';
import 'package:vepay_app/screens/auth/register.dart';
import 'package:vepay_app/services/app_info_service.dart';

import '../../resources/color_manager.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 2 * 0.1, vertical: h * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FancyShimmerImage(
                  boxFit: BoxFit.cover,
                  height: h * 0.25,
                  width: w * 0.5,
                  imageUrl: AppInfoService().getValueByKey('web_splash_image')!,
                  errorWidget: Image.network(
                      'https://vectorified.com/images/user-icon-1.png'),
                ),
                SizedBox(
                  height: h * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                  child: Text(
                    AppInfoService().removeHtmlTags(
                        AppInfoService().getValueByKey('web_splash_title')!),
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                  child: Text(
                    AppInfoService().removeHtmlTags(
                        AppInfoService().getValueByKey('web_splash_desc')!),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: h * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                  child: SizedBox(
                    height: h * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      child: const Text('Daftar'),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                  child: SizedBox(
                    height: h * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white54, // background
                        foregroundColor: ColorManager.primary, // foreground
                      ),
                      child: const Text('Masuk'),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
