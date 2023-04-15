import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/models/blockchain_model.dart';
import 'package:vepay_app/models/payment_method_model.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/services/blockchain_service.dart';
import 'package:vepay_app/services/payment_method_service.dart';

import '../../common/common_dialog.dart';
import '../../common/common_method.dart';
import '../../resources/color_manager.dart';
import '../../services/rate_service.dart';
import '../home/product_buy_detail.dart';
import '../withdraw/withdraw_detail.dart';

class WithdrawTab extends StatefulWidget {
  WithdrawTab({Key? key}) : super(key: key);

  @override
  State<WithdrawTab> createState() => _WithdrawTabState();
}

class _WithdrawTabState extends State<WithdrawTab> {
  List<RateModel> rates = [];
  List<PaymentMethodModel>? methods;
  RateModel? selectedRate;
  PaymentMethodModel? selectedMethod;

  final _formKey = GlobalKey<FormState>();

  TextEditingController fieldController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  final _totalValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan jumlah'),
  ]);

  final _akunValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan akun yang sesuai'),
  ]);

  BlockchainModel? selectedChain;

  @override
  void initState() {
    getRates();
    super.initState();
  }

  getRates() async {
    try {
      rates = await RateService().getRates("withdraw");
      methods = await PaymentMethodService().getMethods();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  buildBottom() {
    return Column(
      children: [
        TextFormField(
          controller: fieldController,
          validator: _akunValidator,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: CommonMethods().getFieldName(selectedRate!.name!),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.primary,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextFormField(
            controller: totalController,
            validator: _totalValidator,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Jumlah',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.primary,
                ),
              ),
              suffixIcon: SizedBox(
                height: 50,
                width: 100,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (totalController.text == "" ||
                              int.parse(totalController.text.trim()) == 0) {
                            CommonDialog.buildOkDialog(
                                context, false, "Jumlah harus lebih dari 0");

                            totalController.text = 1.toString();
                          } else {
                            setState(() {
                              int total = int.parse(totalController.text) - 1;
                              totalController.text = total.toString();
                            });
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 2, color: Colors.grey)),
                              child: const Icon(
                                FontAwesomeIcons.minus,
                                color: Colors.grey,
                                size: 20,
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (totalController.text == "") {
                            totalController.text = 1.toString();
                          } else {
                            int total = int.parse(totalController.text) + 1;
                            totalController.text = total.toString();
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 2, color: Colors.grey)),
                              child: const Icon(
                                FontAwesomeIcons.plus,
                                color: Colors.grey,
                                size: 20,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<PaymentMethodModel>(
                    iconSize: 0.0,
                    underline: const SizedBox(),
                    value: selectedMethod,
                    hint: const Text("Metode Pencairan"),
                    items: methods!
                        .map<DropdownMenuItem<PaymentMethodModel>>((value) {
                      return DropdownMenuItem<PaymentMethodModel>(
                        value: value,
                        child: Text(value.metode!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(
                        () {
                          selectedMethod = value;
                        },
                      );

                      //showFields();
                    },
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.arrow_drop_down)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<RateModel>(
                          iconSize: 0.0,
                          underline: const SizedBox(),
                          value: selectedRate,
                          hint: const Text("Pilih Jenis Produk"),
                          items:
                              rates.map<DropdownMenuItem<RateModel>>((value) {
                            return DropdownMenuItem<RateModel>(
                              value: value,
                              child: Text(value.name!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                selectedRate = value;
                              },
                            );

                            //showFields();
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.arrow_drop_down)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              selectedRate == null ? Container() : buildBottom(),
              const SizedBox(height: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 60),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary, // background
                          foregroundColor: Colors.white, // foreground
                        ),
                        child: const Text('Selanjutnya'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if ((selectedRate!.name!.toLowerCase() ==
                                        "paypal" ||
                                    selectedRate!.name!.toLowerCase() ==
                                        "skrill" ||
                                    selectedRate!.name!.toLowerCase() ==
                                        "neteller") &&
                                !CommonMethods()
                                    .isEmail(fieldController.text)) {
                              CommonDialog.buildOkDialog(
                                  context, false, "Harap isi email yang valid");
                            } else {
                              if (int.parse(totalController.text.trim()) == 0) {
                                CommonDialog.buildOkDialog(context, false,
                                    "Jumlah harus lebih dari 0");
                              } else {
                                if (selectedRate!.categories!.toLowerCase() ==
                                        "crypto" &&
                                    selectedChain == null) {
                                  CommonDialog.buildOkDialog(context, false,
                                      "Harap pilih blockchain terlebih dahulu");
                                } else {
                                  Map<String, dynamic> data = {
                                    "akun_tujuan": fieldController.text.trim(),
                                    "jumlah": totalController.text.trim(),
                                    "blockchain_id": selectedChain == null
                                        ? null
                                        : selectedChain!.id,
                                    "blockchain_name": selectedChain == null
                                        ? null
                                        : selectedChain!.blockchain,
                                  };

                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: WithdrawDetail(
                                      rateModel: selectedRate!,
                                      data: data,
                                    ),
                                    withNavBar: false,
                                  );
                                }
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
