import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/transaction_model.dart';

import '../../common/common_method.dart';
import '../../resources/color_manager.dart';

class TransactionDetail extends StatefulWidget {
  TransactionModel transaction;
  TransactionDetail({required this.transaction, Key? key}) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Detail Transaksi"),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTop(),
          const SizedBox(height: 10),
          buildMiddle(),
          const SizedBox(height: 10),
          buildBottom(),
          const SizedBox(height: 20),
        ],
      )),
    );
  }

  buildTop() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaksi ${CommonMethods().getStatusLabel(int.parse(widget.transaction.status!))}",
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            const SizedBox(height: 20),
            CommonWidgets().buildTextItem(
                context, "Kode Transaksi", widget.transaction.kodeTransaksi!),
            const SizedBox(height: 10),
            CommonWidgets().buildTextItem(context, "Tanggal Transaksi",
                CommonMethods().formatDate(widget.transaction.createdAt!, "d")),
            const SizedBox(height: 10),
            CommonWidgets().buildTextItem(
                context, "Jenis Produk", widget.transaction.product!),
          ],
        ),
      ),
    );
  }

  buildMiddle() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Produk",
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 20),
            CommonWidgets().buildTextItem(context, "Jenis Produk",
                "${widget.transaction.product} - ${widget.transaction.type}"),
            widget.transaction.akunTujuan == null
                ? Container()
                : const SizedBox(height: 10),
            widget.transaction.akunTujuan == null
                ? Container()
                : CommonWidgets().buildTextItem(
                    context,
                    CommonMethods().getFieldName(widget.transaction.product!),
                    widget.transaction.akunTujuan ?? ""),
            const SizedBox(height: 10),
            CommonWidgets()
                .buildTextItem(context, "Nama", widget.transaction.name!),
            const SizedBox(height: 10),
            CommonWidgets().buildTextItem(
              context,
              "Subtotal Tagihan",
              CommonMethods().formatRupiahNumString(widget.transaction.subTotal!),
            ),
            const SizedBox(height: 10),
            CommonWidgets().buildTextItem(
              context,
              "Biaya Transaksi",
              CommonMethods().formatRupiahNumString(widget.transaction.fee!),
            ),
            widget.transaction.type!.toLowerCase() == "withdraw"
                ? Container()
                : const SizedBox(height: 10),
            widget.transaction.type!.toLowerCase() == "withdraw"
                ? Container()
                : CommonWidgets().buildTextItem(
                    context,
                    "Potongan diskon",
                    CommonMethods().formatRupiahNumString(widget.transaction.potonganDiskon!.toString()),
                  ),
            const SizedBox(height: 10),
            CommonWidgets().buildTextItem(
              context,
              "Total",
              widget.transaction.type!.toLowerCase() == "withdraw"
                  ? "\$${widget.transaction.total}"
                  : CommonMethods().formatRupiahNumString(widget.transaction.total!),
            ),
          ],
        ),
      ),
    );
  }

  buildBottom() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              "Rincian Pembayaran",
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 20),
            widget.transaction.type!.toLowerCase() == "withdraw"
                ? Container()
                : CommonWidgets().buildTextItem(
                    context, "Metode Pembayaran", widget.transaction.metode!),
            widget.transaction.type!.toLowerCase() == "withdraw"
                ? Container()
                : const SizedBox(height: 10),
            CommonWidgets().buildTextItem(
                context,
                "Status Pembayaran",
                CommonMethods()
                    .getStatusLabel(int.parse(widget.transaction.status!))),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
              height: 2,
            ),
            const SizedBox(height: 20),
            CommonWidgets().buildTextItem(
                context,
                "Sub Total Bayar",
                CommonMethods.formatCompleteCurrency(
                  double.parse(widget.transaction.subTotal!),
                )),
            const SizedBox(height: 10),
            CommonWidgets().buildTextItem(
                context,
                "Total Bayar",
                widget.transaction.type!.toLowerCase() == "withdraw"
                    ? "\$${widget.transaction.total}"
                    : CommonMethods.formatCompleteCurrency(
                        double.parse(widget.transaction.total!),
                      )),
            // const SizedBox(height: 10),
            // CommonWidgets().buildTextItem(
            //     context,
            //     "Diskon",
            //     CommonMethods.formatCompleteCurrency(
            //       0,
            //     )),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pembayaran",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 18,
                      ),
                ),
                Text(
                  widget.transaction.type!.toLowerCase() == "withdraw"
                      ? "\$${widget.transaction.total}"
                      : CommonMethods.formatCompleteCurrency(
                          double.parse(widget.transaction.total!),
                        ),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 18,
                      ),
                )
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background
                  foregroundColor: Colors.white, // foreground
                ),
                child: const Text('Lihat Bukti Pembayaran'),
                onPressed: () async {
                  showImageViewer(
                      context, Image.network(widget.transaction.bukti!).image,
                      swipeDismissible: true, doubleTapZoomable: true);
                },
              ),
            ),
            const SizedBox(height: 10),
            widget.transaction.buktiVerif == ""
                ? Container()
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      child: const Text('Lihat Bukti Proses Admin'),
                      onPressed: () async {
                        showImageViewer(context,
                            Image.network(widget.transaction.buktiVerif!).image,
                            swipeDismissible: true, doubleTapZoomable: true);
                      },
                    ),
                  ),
            widget.transaction.buktiVerif == ""
                ? Container()
                : const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary, // background
                  foregroundColor: Colors.white, // foreground
                ),
                child: const Text('Kembali'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
