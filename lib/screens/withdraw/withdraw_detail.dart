import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/blockchain_model.dart';
import 'package:vepay_app/resources/text_style_manager.dart';
import 'package:vepay_app/resources/widget_manager.dart';
import 'package:vepay_app/screens/withdraw/withdraw_pembayaran.dart';

import '../../common/common_dialog.dart';
import '../../common/common_method.dart';
import '../../models/rate_model.dart';
import '../../models/transaction_model.dart';
import '../../models/withdraw_model.dart';
import '../../resources/color_manager.dart';
import '../../services/transaction_service.dart';

class WithdrawDetail extends StatefulWidget {
  RateModel rateModel;
  WithdrawModel withdrawModel;
  BlockchainModel? blockchainModel;
  Map<String, dynamic> data;
  String wdSource;

  WithdrawDetail(
      {required this.rateModel,
      required this.withdrawModel,
      this.blockchainModel,
      required this.data,
      required this.wdSource,
      super.key});

  @override
  State<WithdrawDetail> createState() => _WithdrawDetailState();
}

class _WithdrawDetailState extends State<WithdrawDetail> {
  double? subtotal;
  double? subtotalUsd;
  double? total;
  double? feeFinal;
  double? totalPromo = 0;

  TextEditingController promoController = TextEditingController();

  double? biayaTransaksi;

  bool isLoading = false;

  @override
  void initState() {
    double fee = 0;

    if (double.parse(widget.rateModel.fee!) == 0) {
      fee = 0;
    } else {
      double price = double.parse(widget.rateModel.price!);
      // double juml = double.parse(widget.data['jumlah']) * price;

      // double feeInRp = (juml * double.parse(widget.rateModel.fee!) / 100);
      double feeInRp = setWithdrawFeeInRp(price);

      double tempFeeRp = feeInRp;

      fee = tempFeeRp / price;

      // round to 3 decimal places
      fee = double.parse(fee.toStringAsFixed(3));
    }

    biayaTransaksi = fee;

    setState(() {});

    countAll(
      double.parse(widget.rateModel.price!),
      double.parse(widget.data['jumlah']),
      fee,
      totalPromo!,
    );

    super.initState();
  }

  getDefaultFee(double price, double amount) {
    double sub = price * amount;

    if (widget.rateModel.feeType == "%") {
      return (double.parse(widget.rateModel.fee!) * sub) / 100;
    } else {
      return double.parse(widget.rateModel.fee!);
    }
  }

  setWithdrawFeeInRp(double price) {
    double tempFee = 0;

    // get fee from rules
    double jumlah = double.parse(widget.data['jumlah']!);

    if (widget.rateModel.rules == null || widget.rateModel.rules!.isEmpty) {
      // get default fee
      tempFee = getDefaultFee(price, jumlah);
    } else {
      bool isAnyRuleMatched = false;
      int ruleIndex = 0;

      for (var rule in widget.rateModel.rules!) {
        String condition = rule.condition!;
        // conditions will be like =, >, <, >=, <=, !=

        // if matched, get rule index and break the loop
        if (condition == "=") {
          if (jumlah == double.parse(rule.quantity!)) {
            isAnyRuleMatched = true;
            break;
          }
        } else if (condition == ">") {
          if (jumlah > double.parse(rule.quantity!)) {
            isAnyRuleMatched = true;
            break;
          }
        } else if (condition == "<") {
          if (jumlah < double.parse(rule.quantity!)) {
            isAnyRuleMatched = true;
            break;
          }
        } else if (condition == ">=") {
          if (jumlah >= double.parse(rule.quantity!)) {
            isAnyRuleMatched = true;
            break;
          }
        } else if (condition == "<=") {
          if (jumlah <= double.parse(rule.quantity!)) {
            isAnyRuleMatched = true;
            break;
          }
        } else if (condition == "!=") {
          if (jumlah != double.parse(rule.quantity!)) {
            isAnyRuleMatched = true;
            break;
          }
        }
      }

      if (isAnyRuleMatched) {
        // get fee from matched rule
        String feeType = widget.rateModel.rules![ruleIndex].type!;

        if (feeType == "%") {
          double sub = price * jumlah;
          tempFee =
              (double.parse(widget.rateModel.rules![ruleIndex].fee!) * sub) /
                  100;
        } else {
          tempFee = double.parse(widget.rateModel.rules![ruleIndex].fee!);
        }
      } else {
        tempFee = getDefaultFee(price, jumlah);
      }
    }

    // round to 2 decimal places
    tempFee = double.parse(tempFee.toStringAsFixed(3));

    return tempFee;
  }

  // countAll(double price, double amount, double promo) {
  //   subtotal = price * amount;

  //   if (widget.blockchainModel == null) {
  //     feeFinal = setFee(subtotal!);
  //   } else {
  //     feeFinal = double.parse(widget.blockchainModel!.fee!);
  //   }

  //   double tempTotal = (subtotal! + feeFinal!);

  //   total = tempTotal - promo;

  //   setState(() {});
  // }

  countAll(double price, double amount, double fee, double promo) {
    subtotal = ((amount - fee) * price);
    subtotalUsd = amount - fee;

    total = amount;

    setState(() {});
  }

  buildTopSection() {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FancyShimmerImage(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.06,
                      boxFit: BoxFit.cover,
                      imageUrl: widget.rateModel.image!,
                      errorWidget: Image.network(
                          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                      "${widget.rateModel.name!} ${widget.rateModel.type!}",
                      style: TextStyleManager.instance.heading3.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              height: 2,
            ),
            const SizedBox(height: 10),
            WidgetManager()
                .buildTextItem("Jenis Produk", widget.rateModel.name!),
            const SizedBox(height: 10),
            // widget.data['akun_tujuan'] == null
            //     ? Container()
            //     : buildTextItem(
            //         CommonMethods().getFieldName(widget.rateModel.name!),
            //         widget.data['akun_tujuan']!),
            // widget.data['akun_tujuan'] == null
            //     ? Container()
            //     : const SizedBox(height: 10),
            widget.data['blockchain_name'] == null
                ? Container()
                : WidgetManager().buildTextItem(
                    "Blockchain", widget.data['blockchain_name']!),
            widget.data['blockchain_name'] == null
                ? Container()
                : const SizedBox(height: 10),
            // ignore: prefer_interpolation_to_compose_strings
            WidgetManager()
                // ignore: prefer_interpolation_to_compose_strings
                .buildTextItem(
                    "Jumlah",
                    CommonMethods().formatCurrencyNum(
                        widget.rateModel.name,
                        CommonMethods().parsePreservingTypeWithComma(
                            widget.data['jumlah']!))),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem(
              "Rate Withdraw",
              CommonMethods.formatCompleteCurrency(
                double.parse(widget.rateModel.price!),
              ),
            ),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem(
              "Biaya Transaksi",
              "\$${biayaTransaksi!}",
            ),
          ],
        ),
      ),
    );
  }

  buildMiddleSection() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Withdraw",
              style: TextStyleManager.instance.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            WidgetManager().buildTextItem2(
              "Subtotal Tagihan",
              CommonMethods()
                  .formatCurrencyNum(widget.rateModel.name, subtotalUsd!),
            ),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem2(
              "Subtotal Jumlah yang Diterima",
              CommonMethods.formatCompleteCurrency(
                subtotal!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildBottomSection() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("Total Pembayaran",
                  style: TextStyleManager.instance.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Text(
                CommonMethods()
                    .formatCurrencyNum(widget.rateModel.name, total!),
                style: TextStyleManager.instance.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets()
          .buildCommonAppBar("${widget.rateModel.name!} Withdraw"),
      body: ListView(
        children: [
          buildTopSection(),
          const SizedBox(height: 10),
          buildMiddleSection(),
          const SizedBox(height: 10),
          buildBottomSection(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  onPressed: isLoading
                      ? () {}
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          widget.data['sub_total'] = subtotal!;
                          widget.data['sub_total_usd'] = subtotalUsd!;
                          widget.data['total'] = total!;
                          widget.data['fee'] = biayaTransaksi;
                          widget.data['total_promo'] = totalPromo;

                          Map<String, dynamic> data = {
                            'm_metode_id': widget.data["m_metode_id"],
                            'm_rate_id': widget.rateModel.id,
                            'jumlah': widget.data['jumlah'],
                            'sub_total': subtotal,
                            'total_bayar': total,
                            'akun_tujuan': widget.data['akun_tujuan'],
                            'no_rek': widget.data['no_rek'],
                            'blockchain': widget.data['blockchain_id'],
                            'promo_id': widget.data['promo_id'],
                            'total_promo': 0,
                          };

                          setState(() {});

                          doTransaction(data);
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Bayar'),
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
        screen: WithdrawPayment(
          trData: widget.data,
          transactionModel: t,
          withdrawModel: widget.withdrawModel,
          wdSource: widget.wdSource,
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
