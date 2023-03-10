import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';

import '../../resources/color_manager.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Hubungi Kami"),
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                // margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  // borderRadius:
                  //     const BorderRadius.all(Radius.circular(10)), //here
                  color: ColorManager.primary,
                ),
              )
            ],
          ),
          Column(
            children: [
              Image(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                image: const AssetImage('assets/logo_white.png'),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
