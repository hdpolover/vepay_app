import 'package:expansion_widget/expansion_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/models/payment_method_model.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/models/transaction_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/home/payment_detail.dart';
import 'package:vepay_app/services/payment_method_service.dart';
import 'package:vepay_app/services/transaction_service.dart';

import '../../common/common_method.dart';
import '../../common/common_widgets.dart';

class ProductPaymentMethod extends StatefulWidget {
  RateModel rateModel;
  Map<String, dynamic> data;
  ProductPaymentMethod({required this.rateModel, required this.data, Key? key})
      : super(key: key);

  @override
  State<ProductPaymentMethod> createState() => _ProductPaymentMethodState();
}

class _ProductPaymentMethodState extends State<ProductPaymentMethod> {
  List<PaymentMethodModel>? methods;
  PaymentMethodModel? selectedPaymentMethod;

  bool isLoading = false;

  @override
  void initState() {
    getMethods();
    super.initState();
  }

  getMethods() async {
    try {
      await PaymentMethodService().getMethods().then((value) {
        methods = value;

        // for (var element in methods!) {
        //   paymentOptions.add(PaymentMethodOption(
        //       element.id!, element.image!, element.metode!));
        // }

        setState(() {});
      });
    } catch (e) {
      print(e);
    }
  }

  buildMetodePembayaranSection() {
    // return ExpansionWidget(
    //   initiallyExpanded: false,
    //   titleBuilder: (double animationValue, _, bool isExpaned, toogleFunction) {
    //     return GestureDetector(
    //       onTap: () => toogleFunction(animated: true),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             child: Text(
    //               "Metode Pembayaran",
    //               style: Theme.of(context)
    //                   .textTheme
    //                   .bodyText1
    //                   ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    //             ),
    //           ),
    //           Text(
    //             "Lihat semua",
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .bodyText1
    //                 ?.copyWith(color: ColorManager.primary),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   content: Container(
    //     width: double.infinity,
    //     color: Colors.white,
    //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 10),
    //       child: Text("dd"),
    //     ),
    //   ),
    // );
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Metode Pembayaran",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Lihat semua",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: ColorManager.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              methods == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        children: methods!
                            .map((paymentOptionValue) =>
                                RadioListTile<PaymentMethodModel>(
                                  dense: true,
                                  // visualDensity:
                                  //     const VisualDensity(vertical: -3),
                                  activeColor: ColorManager.primary,
                                  groupValue: selectedPaymentMethod,
                                  title: Row(
                                    children: [
                                      FancyShimmerImage(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        boxFit: BoxFit.cover,
                                        imageUrl: paymentOptionValue.image!,
                                        errorWidget: Image.network(
                                            'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          paymentOptionValue.metode!,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: paymentOptionValue,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPaymentMethod = val;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  buildTotalSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jumlah yang harus dibayarkan",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildTextItem2(
                "Subtotal Tagihan",
                CommonMethods.formatCompleteCurrency(
                  widget.data['sub_total'],
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem2(
                "Biaya Transaksi",
                CommonMethods.formatCompleteCurrency(
                  widget.data['fee'],
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem2(
                "Total",
                CommonMethods.formatCompleteCurrency(
                  widget.data['total'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTextItem2(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title)),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Pembayaran"),
      body: Column(
        children: [
          buildMetodePembayaranSection(),
          const SizedBox(height: 10),
          buildTotalSection(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary, // background
                            foregroundColor: Colors.white, // foreground
                          ),
                          child: const Text('Bayar'),
                          onPressed: () async {
                            if (selectedPaymentMethod == null) {
                              CommonDialog.buildOkDialog(context, false,
                                  "Harap pilih metode pembayaran terlebih dahulu.");
                            } else {
                              setState(() {
                                isLoading = true;
                              });

                              var prefs = await SharedPreferences.getInstance();

                              String? userId = prefs.getString("user_id");
                              int metodeId =
                                  int.parse(selectedPaymentMethod!.id!);
                              int rateId = int.parse(widget.rateModel.id!);
                              int jumlah = int.parse(widget.data['jumlah']);
                              double bayar = widget.data['total'];
                              double subtotal = widget.data['sub_total'];

                              Map<String, dynamic> data = {
                                'user_id': userId,
                                'm_metode_id': metodeId,
                                'm_rate_id': rateId,
                                'jumlah': jumlah,
                                'sub_total': subtotal,
                                'total_bayar': bayar,
                                'akun_tujuan': widget.data['akun_tujuan'],
                                'blockchain': widget.data['blockchain_id'],
                              };

                              doTransaction(data);
                            }
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  doTransaction(Map<String, dynamic> data) async {
    try {
      TransactionModel t = await TransactionService().createTransaction(data);

      setState(() {
        isLoading = false;
      });

      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: PaymentDetail(
          transactionModel: t,
        ),
        withNavBar: false,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CommonDialog.buildOkDialog(context, false, e.toString());
    }
  }
}
