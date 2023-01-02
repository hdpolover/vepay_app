import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Hubungi Kami"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
