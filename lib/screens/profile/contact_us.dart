import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/resources/text_style_manager.dart';

import '../../resources/color_manager.dart';
import '../../services/app_info_service.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CommonWidgets().buildFloatingWaButton(),
      appBar: CommonWidgets().buildCommonAppBar("Hubungi Kami"),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              color: ColorManager.primary,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Container(
                width: 180,
                height: 120,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/logo_white.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  // height: MediaQuery.of(context).size.height * 0.15,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 40.0 : 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  AppInfoService().removeHtmlTags(AppInfoService().getValueByKey('web_title')!),
                                  style: TextStyleManager.instance.heading3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: isTablet ? 24.0 : 20.0),
                              Text("Alamat", style: TextStyleManager.instance.body2),
                              SizedBox(height: isTablet ? 12.0 : 10.0),
                              Text(
                                AppInfoService().removeHtmlTags(AppInfoService().getValueByKey('web_alamat')!),
                                style: TextStyleManager.instance.body2,
                              ),
                              SizedBox(height: isTablet ? 24.0 : 20.0),
                              Text("Email", style: TextStyleManager.instance.body2),
                              SizedBox(height: isTablet ? 12.0 : 10.0),
                              Text(
                                AppInfoService().removeHtmlTags(AppInfoService().getValueByKey('web_email')!),
                                style: TextStyleManager.instance.body2,
                              ),
                              SizedBox(height: isTablet ? 24.0 : 20.0),
                              Text("WhatsApp", style: TextStyleManager.instance.body2),
                              SizedBox(height: isTablet ? 12.0 : 10.0),
                              Text(
                                AppInfoService().removeHtmlTags(AppInfoService().getValueByKey('web_telepon')!),
                                style: TextStyleManager.instance.body2,
                              ),
                              SizedBox(height: isTablet ? 24.0 : 20.0),
                              Text("Website", style: TextStyleManager.instance.body2),
                              SizedBox(height: isTablet ? 12.0 : 10.0),
                              Text(
                                AppInfoService().removeHtmlTags(AppInfoService().getValueByKey('web_website')!),
                                style: TextStyleManager.instance.body2,
                              ),
                              SizedBox(height: isTablet ? 36.0 : 30.0),
                              Center(
                                child: Text(
                                  AppInfoService().removeHtmlTags(AppInfoService().getValueByKey('web_info_desc')!),
                                  style: TextStyleManager.instance.body2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
