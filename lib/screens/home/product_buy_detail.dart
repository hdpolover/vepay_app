import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/screens/home/product_payment_method.dart';

import '../../common/common_widgets.dart';
import '../../resources/color_manager.dart';

class ProductBuyDetail extends StatefulWidget {
  RateModel rateModel;
  Map<String, dynamic> data;
  ProductBuyDetail({required this.rateModel, required this.data, Key? key})
      : super(key: key);

  @override
  State<ProductBuyDetail> createState() => _ProductBuyDetailState();
}

class _ProductBuyDetailState extends State<ProductBuyDetail> {
  double? subtotal;
  double? total;
  double? feeFinal;

  @override
  void initState() {
    countAll(
      double.parse(widget.rateModel.price!),
      double.parse(widget.data['jumlah']),
      double.parse(widget.rateModel.fee!),
    );

    super.initState();
  }

  countAll(double price, double amount, double fee) {
    subtotal = price * amount;

    feeFinal = (fee * subtotal!) / 100;
    total = subtotal! + feeFinal!;

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
              .bodyText1
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
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  buildTopSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: widget.data['blockchain_name'] == null
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.33,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
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
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 17,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              const SizedBox(height: 10),
              buildTextItem("Jenis Produk", widget.rateModel.name!),
              const SizedBox(height: 10),
              widget.data['akun_tujuan'] == null
                  ? Container()
                  : buildTextItem(
                      CommonMethods().getFieldName(widget.rateModel.name!),
                      widget.data['akun_tujuan']!),
              widget.data['akun_tujuan'] == null
                  ? Container()
                  : const SizedBox(height: 10),
              widget.data['blockchain_name'] == null
                  ? Container()
                  : buildTextItem(
                      "Blockchain", widget.data['blockchain_name']!),
              widget.data['blockchain_name'] == null
                  ? Container()
                  : const SizedBox(height: 10),
              buildTextItem("Jumlah", widget.data['jumlah']!),
              const SizedBox(height: 10),
              buildTextItem(
                "Harga Satuan",
                CommonMethods.formatCompleteCurrency(
                  double.parse(widget.rateModel.price!),
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem(
                "Biaya Transaksi",
                CommonMethods.formatCompleteCurrency(
                  feeFinal!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildMiddleSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detail Pembayaran",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildTextItem2(
                "Subtotal Tagihan",
                CommonMethods.formatCompleteCurrency(
                  subtotal!,
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem2(
                "Kode Promosi", "-Rp0,00",
                // "-${CommonMethods.formatCompleteCurrency(
                //   double.parse(widget.rateModel.fee!),
                // )}",
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBottomSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Total Pembayaran",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Text(
                CommonMethods.formatCompleteCurrency(
                  total!,
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar(widget.rateModel.name!),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildTopSection(),
          const SizedBox(height: 10),
          buildMiddleSection(),
          const SizedBox(height: 10),
          buildBottomSection(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    child: const Text('Pilih Metode Pembayaran'),
                    onPressed: () async {
                      // if (_formKey.currentState!.validate()) {
                      //   Map<String, dynamic> data = {
                      //     "email": emailController.text.trim(),
                      //     "jumlah": totalController.text.trim(),
                      //   };

                      widget.data['sub_total'] = subtotal!;
                      widget.data['total'] = total!;
                      widget.data['fee'] = feeFinal;

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: ProductPaymentMethod(
                          rateModel: widget.rateModel,
                          data: widget.data,
                        ),
                        withNavBar: false,
                      );
                      // }
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
}
