import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'services/app_info_service.dart';

class Maintenance extends StatefulWidget {
  Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
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
                Image(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.3,
                  image: const AssetImage('assets/sorry.png'),
                ),
                // FancyShimmerImage(
                //   boxFit: BoxFit.cover,
                //   height: h * 0.25,
                //   width: w * 0.5,
                //   // imageUrl: AppInfoService().getValueByKey('web_splash_image')!,

                //   errorWidget: Image.network(
                //       'https://vectorified.com/images/user-icon-1.png'),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                  child: Text(
                    "Service Under Maintenance",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
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
                    "Mohon maaf! Saat ini layanan Vepay sedang dalam masa perbaikan. Silakan coba beberapa saat lagi.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
