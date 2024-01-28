import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/blockchain_model.dart';
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
      double juml = double.parse(widget.data['jumlah']) * price;

      double feeInRp = (juml * double.parse(widget.rateModel.fee!) / 100);

      double tempFeeRp = feeInRp;

      fee = tempFeeRp / price;
    }
    //}

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

  countAll(double price, double amount, double fee, double promo) {
    subtotal = ((amount - fee) * price);
    subtotalUsd = amount - fee;

    total = amount;

    setState(() {});
  }

  buildTextItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Text(title)),
        Expanded(
            child: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        )),
      ],
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
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  buildTopSection() {
    return Card(
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 17,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              height: 2,
            ),
            const SizedBox(height: 10),
            buildTextItem("Jenis Produk", widget.rateModel.name!),
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
                : buildTextItem("Blockchain", widget.data['blockchain_name']!),
            widget.data['blockchain_name'] == null
                ? Container()
                : const SizedBox(height: 10),
            // ignore: prefer_interpolation_to_compose_strings
            buildTextItem("Jumlah", "\$" + widget.data['jumlah']!),
            const SizedBox(height: 10),
            buildTextItem(
              "Rate Withdraw",
              CommonMethods.formatCompleteCurrency(
                double.parse(widget.rateModel.price!),
              ),
            ),
            const SizedBox(height: 10),
            buildTextItem(
              "Biaya Transaksi",
              "\$${biayaTransaksi!.toStringAsFixed(2)}",
            ),
          ],
        ),
      ),
    );
  }

  buildMiddleSection() {
    return Card(
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
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            buildTextItem2(
              "Subtotal Tagihan",
              "\$${subtotalUsd!.toStringAsFixed(2)}",
            ),
            const SizedBox(height: 10),
            buildTextItem2(
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
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Total Pembayaran",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Text(
              "\$${total!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
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
