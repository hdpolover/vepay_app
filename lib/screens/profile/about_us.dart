import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/resources/color_manager.dart';

import '../../services/app_info_service.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CommonWidgets().buildFloatingWaButton(),
      appBar: CommonWidgets().buildCommonAppBar("Tentang Kami"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)), //here
                        color: ColorManager.primary,
                      ),
                      child: Image(
                        width: MediaQuery.of(context).size.width * 0.3,
                        image: const AssetImage('assets/logo_white.png'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          AppInfoService().removeHtmlTags(
                              AppInfoService().getValueByKey('web_app_name')!),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          version == null ? "v -" : "v$version",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text(
                  AppInfoService().removeHtmlTags(
                      AppInfoService().getValueByKey('web_desc')!),
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
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
