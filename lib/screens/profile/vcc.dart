import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/common/common_widgets.dart';

class Vcc extends StatefulWidget {
  Vcc({Key? key}) : super(key: key);

  @override
  State<Vcc> createState() => _VccState();
}

class _VccState extends State<Vcc> {
  buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Image(
              width: MediaQuery.of(context).size.width * 0.4,
              image: const AssetImage('assets/sorry.png'),
            ),
            const SizedBox(height: 20),
            Text(
              "Yah, kamu belum punya VCC!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              "Jangan kuatir! VCC dapat kamu beli di Vepay.id dengan proses yang sangat mudah dan cepat",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Virtual Credit Card"),
      body: SafeArea(
        child: SingleChildScrollView(
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     buildEmpty(),
          //   ],
          // ),
          child: buildEmpty(),
        ),
      ),
    );
  }
}
