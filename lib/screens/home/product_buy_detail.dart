import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/resources/text_style_manager.dart';
import 'package:vepay_app/resources/widget_manager.dart';
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
      super.key});

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
      totalPromo!,
    );

    super.initState();
  }

  checkPromo() async {
    try {
      selectedPromo = await PromoService().check(promoController.text.trim());

      if (selectedPromo!.minimumTransaksi! > subtotal!) {
        CommonDialog.buildOkDialog(context, false,
            "Minimum transaksi untuk promo ini belum terpenuhi");

        setState(() {
          isPromoValid = false;
        });
      } else {
        CommonDialog.buildOkDialog(
            context, true, "Kode promo berhasil digunakan");

        setState(() {
          isPromoValid = true;

          countPromo(selectedPromo!);
        });
      }
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
      totalPromo!,
    );
  }

  countPromo(PromoModel p) {
    double maksPromo = p.maksimalPromo!.toDouble();

    if (p.jenis == "2") {
      double nilaiPromo = (total! * p.value!) / 100;

      if (nilaiPromo > maksPromo) {
        setState(() {
          totalPromo = maksPromo;
        });

        countAll(
          double.parse(widget.rateModel.price!),
          double.parse(widget.data['jumlah']),
          totalPromo!,
        );
      } else {
        setState(() {
          totalPromo = nilaiPromo;
        });
        countAll(
          double.parse(widget.rateModel.price!),
          double.parse(widget.data['jumlah']),
          totalPromo!,
        );
      }
    } else {
      setState(() {
        totalPromo = double.parse(p.value!.toString());
      });

      countAll(
        double.parse(widget.rateModel.price!),
        double.parse(widget.data['jumlah']),
        totalPromo!,
      );
    }
  }

  getDefaultFee() {
    if (widget.rateModel.feeType == "%") {
      return (double.parse(widget.rateModel.fee!) * subtotal!) / 100;
    } else {
      return double.parse(widget.rateModel.fee!);
    }
  }

  setFee(double subtotal) {
    double tempFee = 0;

    if (widget.rateModel.rules == null || widget.rateModel.rules!.isEmpty) {
      // get default fee
      tempFee = getDefaultFee();
    } else {
      // get fee from rules
      double jumlah = double.parse(widget.data['jumlah']!);

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
          tempFee = (double.parse(widget.rateModel.rules![ruleIndex].fee!) *
                  subtotal) /
              100;
        } else {
          tempFee = double.parse(widget.rateModel.rules![ruleIndex].fee!);
        }
      } else {
        tempFee = getDefaultFee();
      }
    }

    return tempFee;
  }

  countAll(double price, double amount, double promo) {
    subtotal = price * amount;

    if (widget.blockchainModel == null) {
      feeFinal = setFee(subtotal!);
    } else {
      feeFinal = double.parse(widget.blockchainModel!.fee!);
    }

    double tempTotal = (subtotal! + feeFinal!);

    total = tempTotal - promo;

    setState(() {});
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
                      widget.rateModel.categories!.toLowerCase() == "vcc"
                          ? "Beli ${widget.rateModel.name!}"
                          : "${widget.rateModel.name!} ${widget.rateModel.type!}",
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
            widget.data['akun_tujuan'] == null
                ? Container()
                : WidgetManager().buildTextItem(
                    CommonMethods().getFieldName(widget.rateModel.name!),
                    widget.data['akun_tujuan']!),
            widget.data['akun_tujuan'] == null
                ? Container()
                : const SizedBox(height: 10),
            widget.data['blockchain_name'] == null
                ? Container()
                : WidgetManager().buildTextItem(
                    "Blockchain", widget.data['blockchain_name']!),
            widget.data['blockchain_name'] == null
                ? Container()
                : const SizedBox(height: 10),
            WidgetManager().buildTextItem("Jumlah", CommonMethods().formatCurrencyNum(widget.rateModel.name!, CommonMethods().parsePreservingTypeWithComma(widget.data['jumlah']!))),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem(
              "Harga Satuan",
              CommonMethods.formatCompleteCurrency(
                double.parse(widget.rateModel.price!),
              ),
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
              "Detail Pembayaran",
              style: TextStyleManager.instance.heading3,
            ),
            const SizedBox(height: 20),
            WidgetManager().buildTextItem2(
              "Subtotal Tagihan",
              CommonMethods.formatCompleteCurrency(
                subtotal!,
              ),
            ),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem2(
              "Biaya Transaksi",
              CommonMethods.formatCompleteCurrency(
                feeFinal!,
              ),
            ),
            widget.rateModel.categories!.toLowerCase() == "vcc"
                ? Container()
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      WidgetManager().buildTextItem2(
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
                                  style: TextStyleManager.instance.body2,
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
                                    style: TextStyleManager.instance.body2
                                        .copyWith(
                                      color: ColorManager.primary,
                                    ),
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
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red, // background
                                            foregroundColor:
                                                Colors.white, // foreground
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
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorManager
                                                .primary, // background
                                            foregroundColor:
                                                Colors.white, // foreground
                                          ),
                                          child: Text(
                                            'SIMPAN',
                                            style:
                                                TextStyleManager.instance.body2,
                                          ),
                                          onPressed: () async {
                                            if (promoController
                                                .text.isNotEmpty) {
                                              checkPromo();
                                            } else {
                                              CommonDialog.buildOkDialog(
                                                  context,
                                                  false,
                                                  "Harap masukan kode promo terlebih dahulu");
                                            }
                                          },
                                        ),
                                      ),
                              ],
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  buildBottomSection() {
    return Card(
      // don't give radius to the main card
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Total Pembayaran",
                style: TextStyleManager.instance.heading3,
              ),
            ),
            Text(
              CommonMethods.formatCompleteCurrency(
                total!,
              ),
              style: TextStyleManager.instance.heading3,
            ),
          ],
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
                    widget.data['sub_total'] = subtotal!;
                    widget.data['total'] = total!;
                    widget.data['fee'] = feeFinal;
                    widget.data['total_promo'] = totalPromo;

                    if (selectedPromo != null) {
                      widget.data['promo_id'] = selectedPromo!.id;
                    }

                    setState(() {});

                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ProductPaymentMethod(
                        rateModel: widget.rateModel,
                        data: widget.data,
                      ),
                      withNavBar: false,
                    );
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
