import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/vcc_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/profile/vcc_detail.dart';
import 'package:vepay_app/services/vcc_service.dart';

class Vcc extends StatefulWidget {
  Vcc({Key? key}) : super(key: key);

  @override
  State<Vcc> createState() => _VccState();
}

class _VccState extends State<Vcc> {
  List<VccModel>? vccs;
  @override
  void initState() {
    super.initState();
    getVcc();
  }

  getVcc() async {
    try {
      vccs = await VccService().getVccs();

      print(vccs![0].holder);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

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
          child: vccs == null
              ? buildEmpty()
              : InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: VccDetail(vcc: vccs![0]),
                      withNavBar: false,
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    itemCount: vccs!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return CreditCardWidget(
                        cardBgColor: ColorManager.primary,
                        // glassmorphismConfig: Glassmorphism(
                        //   blurX: 10.0,
                        //   blurY: 10.0,
                        //   gradient: LinearGradient(
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //     colors: <Color>[
                        //       Colors.grey.withAlpha(20),
                        //       Colors.white.withAlpha(20),
                        //     ],
                        //     stops: const <double>[
                        //       0.3,
                        //       0,
                        //     ],
                        //   ),
                        // ),
                        bankName: "VCC",
                        cardNumber: vccs![index].number!,
                        expiryDate: vccs![index].validDate!,
                        cardHolderName: vccs![index].holder!,
                        cvvCode: vccs![index].securityCode!,
                        isHolderNameVisible: true,
                        showBackView: false,
                        isSwipeGestureEnabled: false,
                        onCreditCardWidgetChange:
                            (CreditCardBrand) {}, //true when you want to show cvv(back) view
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
