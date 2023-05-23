import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/screens/home/product_payment_method.dart';
import 'package:vepay_app/services/promo_service.dart';

import '../../common/common_widgets.dart';
import '../../models/blockchain_model.dart';
import '../../resources/color_manager.dart';

class ProductBuyDetail extends StatefulWidget {
  RateModel rateModel;
  BlockchainModel? blockchainModel;
  Map<String, dynamic> data;
  ProductBuyDetail(
      {required this.rateModel,
      this.blockchainModel,
      required this.data,
      Key? key})
      : super(key: key);

  @override
  State<ProductBuyDetail> createState() => _ProductBuyDetailState();
}

class _ProductBuyDetailState extends State<ProductBuyDetail> {
  double? subtotal;
  double? total;
  double? feeFinal;
  double? totalPromo = 0;
  bool isShowPromo = false;
  bool isPromoValid = false;

  PromoModel? selectedPromo;

  TextEditingController promoController = TextEditingController();

  @override
  void initState() {
    countAll(
      double.parse(widget.rateModel.price!),
      double.parse(widget.data['jumlah']),
      double.parse(widget.rateModel.fee!),
      totalPromo!,
    );

    super.initState();
  }

  checkPromo() async {
    try {
      selectedPromo = await PromoService().check(promoController.text.trim());

      CommonDialog.buildOkDialog(
          context, true, "Kode promo berhasil digunakan");

      setState(() {
        isPromoValid = true;

        countPromo(selectedPromo!);
      });
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());
    }
  }

  deletePromoTotal() {
    setState(() {
      totalPromo = 0;
    });

    countAll(
      double.parse(widget.rateModel.price!),
      double.parse(widget.data['jumlah']),
      double.parse(widget.rateModel.fee!),
      totalPromo!,
    );
  }

  countPromo(PromoModel p) {
    double maksPromo = p.maksimalPromo!;

    if (p.jenis == "2") {
      double nilaiPromo = (total! * p.value!) / 100;

      if (nilaiPromo > maksPromo) {
        setState(() {
          totalPromo = maksPromo;
        });

        countAll(
          double.parse(widget.rateModel.price!),
          double.parse(widget.data['jumlah']),
          double.parse(widget.rateModel.fee!),
          totalPromo!,
        );
      } else {
        setState(() {
          totalPromo = nilaiPromo;
        });
        countAll(
          double.parse(widget.rateModel.price!),
          double.parse(widget.data['jumlah']),
          double.parse(widget.rateModel.fee!),
          totalPromo!,
        );
      }
    } else {
      setState(() {
        totalPromo = p.value!;
      });

      countAll(
        double.parse(widget.rateModel.price!),
        double.parse(widget.data['jumlah']),
        double.parse(widget.rateModel.fee!),
        totalPromo!,
      );
    }
  }

  countAll(double price, double amount, double fee, double promo) {
    subtotal = price * amount;

    if (widget.blockchainModel == null) {
      feeFinal = (fee * subtotal!) / 100;
    } else {
      feeFinal = double.parse(widget.blockchainModel!.fee!);
    }

    double tempTotal = (subtotal! + feeFinal!);

    total = tempTotal - promo;

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
            ? MediaQuery.of(context).size.height * 0.27
            : MediaQuery.of(context).size.height * 0.3,
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
                height: 2,
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
        height: isShowPromo
            ? isPromoValid
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.34
            : MediaQuery.of(context).size.height * 0.24,
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
                "Biaya Transaksi",
                CommonMethods.formatCompleteCurrency(
                  feeFinal!,
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem2(
                "Potongan Promosi",
                "-${CommonMethods.formatCompleteCurrency(
                  totalPromo!,
                )}",
              ),
              isPromoValid ? Container() : const SizedBox(height: 15),
              isPromoValid
                  ? Container()
                  : Row(
                      children: [
                        Text(
                          "Punya kode promo?",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            if (isShowPromo) {
                              setState(() {
                                isShowPromo = false;
                              });
                            } else {
                              setState(() {
                                isShowPromo = true;
                              });
                            }
                          },
                          child: Text(
                            "Masukan kode",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: ColorManager.primary),
                          ),
                        ),
                      ],
                    ),
              !isShowPromo ? Container() : const SizedBox(height: 20),
              !isShowPromo
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: promoController,
                            keyboardType: TextInputType.text,
                            readOnly: isPromoValid ? true : false,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "KODE PROMO",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorManager.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        isPromoValid
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // background
                                    foregroundColor: Colors.white, // foreground
                                  ),
                                  child: const Icon((Icons.delete)),
                                  onPressed: () async {
                                    setState(() {
                                      isPromoValid = false;
                                      promoController.clear();

                                      deletePromoTotal();
                                    });
                                  },
                                ),
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorManager.primary, // background
                                    foregroundColor: Colors.white, // foreground
                                  ),
                                  child: const Text('SIMPAN'),
                                  onPressed: () async {
                                    if (promoController.text.isNotEmpty) {
                                      checkPromo();
                                    } else {
                                      CommonDialog.buildOkDialog(context, false,
                                          "Harap masukan kode promo terlebih dahulu");
                                    }
                                  },
                                ),
                              ),
                      ],
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
        height: MediaQuery.of(context).size.height * 0.085,
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
                    widget.data['total_promo'] = totalPromo;

                    if (selectedPromo != null) {
                      widget.data['promo_id'] = selectedPromo!.id;
                    }

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
        ],
      ),
    );
  }
}
