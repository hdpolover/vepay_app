import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/models/blockchain_model.dart';
import 'package:vepay_app/models/payment_method_model.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/models/withdraw_model.dart';
import 'package:vepay_app/services/payment_method_service.dart';

import '../../common/common_dialog.dart';
import '../../common/common_method.dart';
import '../../resources/color_manager.dart';
import '../../services/blockchain_service.dart';
import '../../services/rate_service.dart';
import '../../services/withdraw_service.dart';
import '../withdraw/withdraw_detail.dart';

class WithdrawTab extends StatefulWidget {
  WithdrawTab({Key? key}) : super(key: key);

  @override
  State<WithdrawTab> createState() => _WithdrawTabState();
}

class _WithdrawTabState extends State<WithdrawTab> {
  List<RateModel> rates = [];
  List<WithdrawModel> withdraws = [];
  List<PaymentMethodModel>? methods;
  RateModel? selectedRate;
  WithdrawModel? selectedWithdraw;
  PaymentMethodModel? selectedMethod;

  final _formKey = GlobalKey<FormState>();

  TextEditingController fieldController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController norekController = TextEditingController();

  final _totalValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan jumlah'),
  ]);

  final _akunValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan akun yang sesuai'),
  ]);

  BlockchainModel? selectedChain;
  List<BlockchainModel>? blockchains;
  List<BlockchainModel> newBlockchains = [];

  @override
  void initState() {
    getRates();
    super.initState();
  }

  getRates() async {
    try {
      List<RateModel> temp1 = await RateService().getRates("withdraw");
      methods = await PaymentMethodService().getMethods();
      withdraws = await WithdrawService().getWithdraws();
      blockchains = await BlockchainService().getChains();

      List<RateModel> temp = [];

      for (RateModel item1 in temp1) {
        for (WithdrawModel item2 in withdraws) {
          if (item2.withdraw!
              .toLowerCase()
              .contains(item1.name!.toLowerCase())) {
            temp.add(item1);
            break;
          }
        }
      }

      rates = temp;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  adjustBlockchains(RateModel rate) {
    setState(() {
      newBlockchains.clear();
    });

    for (WithdrawModel item1 in withdraws) {
      if (item1.withdraw!.toLowerCase().contains(rate.name!.toLowerCase())) {
        print(item1.withdraw!.toLowerCase() + "#1");
        for (BlockchainModel item2 in blockchains!) {
          if (item1.withdraw!
              .toLowerCase()
              .contains(item2.blockchain!.toLowerCase())) {
            print(item2.blockchain!.toLowerCase() + "#2");
            newBlockchains.add(item2);
            break;
          }
        }
      }
    }
  }

  buildBottom() {
    return Column(
      children: [
        // TextFormField(
        //   controller: fieldController,
        //   validator: _akunValidator,
        //   keyboardType: TextInputType.text,
        //   decoration: InputDecoration(
        //     border: const OutlineInputBorder(),
        //     hintText: CommonMethods().getFieldName(selectedRate!.name!),
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         color: ColorManager.primary,
        //       ),
        //     ),
        //   ),
        // ),
        selectedRate!.categories!.toLowerCase() != "crypto"
            ? Container()
            : const SizedBox(height: 10),
        blockchains == null || selectedRate == null
            ? Container()
            : selectedRate!.categories!.toLowerCase() == "crypto"
                ? newBlockchains.isEmpty
                    ? Container()
                    : Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                child: DropdownButton<BlockchainModel>(
                                  isExpanded: true,
                                  icon: const FaIcon(FontAwesomeIcons.sortDown),
                                  iconSize: 16,
                                  underline: const SizedBox(),
                                  value: selectedChain,
                                  hint: const Text("Blockchain"),
                                  items: newBlockchains
                                      .map<DropdownMenuItem<BlockchainModel>>(
                                          (value) {
                                    return DropdownMenuItem<BlockchainModel>(
                                      value: value,
                                      child: Text(value.blockchain!),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        selectedChain = value;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                : Container(),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextFormField(
            controller: totalController,
            validator: _totalValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'(^\d*[\.\,]?\d{0,2})')),
            ],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Jumlah',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.primary,
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
                    isExpanded: true,
                    icon: const FaIcon(FontAwesomeIcons.sortDown),
                    iconSize: 16,
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
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        selectedMethod == null ? Container() : const SizedBox(height: 10),
        selectedMethod == null
            ? Container()
            : TextFormField(
                controller: norekController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Nomor rekening/E-Wallet",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorManager.primary,
                    ),
                  ),
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
          child: SingleChildScrollView(
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
                            isExpanded: true,
                            icon: const FaIcon(FontAwesomeIcons.sortDown),
                            iconSize: 16,
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

                              selectedChain = null;

                              adjustBlockchains(selectedRate!);

                              setState(() {});

                              //showFields();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                selectedRate == null ? Container() : buildBottom(),
                const SizedBox(height: 10),
                Align(
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
                          if (selectedRate == null) {
                            CommonDialog.buildOkDialog(context, false,
                                "Silakan pilih produk withdraw yang diinginkan.");
                          } else {
                            if (_formKey.currentState!.validate()) {
                              // if ((selectedRate!.name!.toLowerCase() ==
                              //             "paypal" ||
                              //         selectedRate!.name!.toLowerCase() ==
                              //             "skrill" ||
                              //         selectedRate!.name!.toLowerCase() ==
                              //             "neteller") &&
                              //     !CommonMethods()
                              //         .isEmail(fieldController.text)) {
                              //   CommonDialog.buildOkDialog(context, false,
                              //       "Harap isi email yang valid");
                              // } else {
                              if (selectedRate!.categories!.toLowerCase() ==
                                      "crypto" &&
                                  selectedChain == null) {
                                CommonDialog.buildOkDialog(context, false,
                                    "Harap pilih blockchain terlebih dahulu");
                              } else {
                                if (totalController.text.contains(",")) {
                                  CommonDialog.buildOkDialog(context, false,
                                      "Gunakan titik (.) sebagai pemisah desimal");
                                } else {
                                  if (double.parse(
                                          totalController.text.trim()) ==
                                      0) {
                                    CommonDialog.buildOkDialog(context, false,
                                        "Jumlah harus lebih dari 0");
                                  } else {
                                    if (selectedMethod == null) {
                                      CommonDialog.buildOkDialog(context, false,
                                          "Harap pilih metode pencairan terlebih dahulu");
                                    } else {
                                      if (norekController.text.trim().isEmpty) {
                                        CommonDialog.buildOkDialog(
                                            context,
                                            false,
                                            "Harap isi nomor rekening atau e-wallet tujuan.");
                                      } else {
                                        if (selectedChain != null) {
                                          for (WithdrawModel item2
                                              in withdraws) {
                                            if (item2.withdraw!
                                                    .toLowerCase()
                                                    .contains(selectedChain!
                                                        .blockchain!
                                                        .toLowerCase()) &&
                                                item2.withdraw!
                                                    .toLowerCase()
                                                    .contains(selectedRate!
                                                        .name!
                                                        .toLowerCase())) {
                                              setState(() {
                                                selectedWithdraw = item2;
                                              });

                                              break;
                                            }
                                          }
                                        } else {
                                          for (WithdrawModel item2
                                              in withdraws) {
                                            if (item2.withdraw!
                                                .toLowerCase()
                                                .contains(selectedRate!.name!
                                                    .toLowerCase())) {
                                              setState(() {
                                                selectedWithdraw = item2;
                                              });

                                              break;
                                            }
                                          }
                                        }

                                        Map<String, dynamic> data = {
                                          "akun_tujuan": "-",
                                          'no_rek': norekController.text.trim(),
                                          "jumlah": totalController.text.trim(),
                                          "blockchain_id": selectedChain == null
                                              ? null
                                              : selectedChain!.id,
                                          "blockchain_name":
                                              selectedChain == null
                                                  ? null
                                                  : selectedChain!.blockchain,
                                          "m_metode_id": selectedMethod!.id!,
                                          'potongan_diskon': 0,
                                        };

                                        RateModel chosenRate = selectedRate!;
                                        WithdrawModel chosenWd =
                                            selectedWithdraw!;
                                        BlockchainModel? chosenbc =
                                            selectedChain ?? null;

                                        setState(() {
                                          selectedRate == null;
                                          selectedWithdraw = null;
                                          selectedChain = null;
                                        });

                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: WithdrawDetail(
                                            rateModel: chosenRate,
                                            withdrawModel: chosenWd,
                                            blockchainModel: chosenbc,
                                            data: data,
                                            wdSource: "tab",
                                          ),
                                          withNavBar: false,
                                        );
                                      }
                                    }
                                  }
                                }
                              }
                              //  }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
