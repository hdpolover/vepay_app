import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';
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

  Future<void> getVcc() async {
    try {
      vccs = await VccService().getVccs();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Detect device type and orientation
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Virtual Credit Card"),
      body: SafeArea(
        child: vccs == null
            ? buildEmpty()
            : RefreshIndicator(
                onRefresh: getVcc,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine layout based on screen size
                    final crossAxisCount =
                        ResponsiveBreakpoints.of(context).isDesktop
                            ? (isLandscape ? 3 : 2)
                            : ResponsiveBreakpoints.of(context).isTablet
                                ? (isLandscape ? 3 : 2)
                                : ResponsiveBreakpoints.of(context).isMobile
                                    ? (isLandscape ? 2 : 1)
                                    : 1;
                    final horizontalPadding =
                        ResponsiveBreakpoints.of(context).isDesktop
                            ? 16.0
                            : 10.0;

                    // Credit card standard aspect ratio is approximately 1.6:1 (width:height)
                    final creditCardAspectRatio =
                        1.6; // Standard ratio for phones

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 10.0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: creditCardAspectRatio,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        // mainAxisExtent: 220, // Approximate height for credit card widget
                      ),
                      itemCount: vccs!.length,
                      itemBuilder: (context, index) {
                        return buildCreditCard(context, index);
                      },
                    );
                  },
                ),
              ),
        ),
      );
  }

  Widget buildCreditCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: VccDetail(vcc: vccs![index]),
          withNavBar: false,
        );
      },
      child: CreditCardWidget(
        cardBgColor: ColorManager.primary,
        bankName: "VCC",
        cardNumber: vccs![index].number!,
        expiryDate: vccs![index].validDate!,
        cardHolderName: vccs![index].holder!,
        cvvCode: vccs![index].securityCode!,
        isHolderNameVisible: true,
        showBackView: false,
        isSwipeGestureEnabled: false,
        onCreditCardWidgetChange: (CreditCardBrand) {},
        obscureInitialCardNumber: true,
        cardType: vccs![index].jenisVcc!.toLowerCase() == "visa"
            ? CardType.visa
            : CardType.mastercard,
      ),
    );
  }
}
