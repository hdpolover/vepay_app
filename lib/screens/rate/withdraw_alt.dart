import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vepay_app/models/blockchain_model.dart';
import 'package:vepay_app/models/payment_method_model.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/services/blockchain_service.dart';
import 'package:vepay_app/services/payment_method_service.dart';

import '../../common/common_dialog.dart';
import '../../models/withdraw_model.dart';
import '../../resources/color_manager.dart';
import '../../services/withdraw_service.dart';
import '../withdraw/withdraw_detail.dart';

class WithdrawAlt extends StatefulWidget {
  final RateModel rateModel;

  const WithdrawAlt({required this.rateModel, super.key});

  @override
  State<WithdrawAlt> createState() => _WithdrawAltState();
}

class _WithdrawAltState extends State<WithdrawAlt> {
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
    setState(() {
      selectedRate = widget.rateModel;
    });

    getRates();
    super.initState();
  }

  getRates() async {
    try {
      blockchains = await BlockchainService().getChains();
      methods = await PaymentMethodService().getMethods();
      withdraws = await WithdrawService().getWithdraws();

      for (WithdrawModel item2 in withdraws) {
        if (selectedRate!.name!.toLowerCase() ==
            item2.withdraw!.toLowerCase()) {
          setState(() {
            selectedWithdraw = item2;
          });

          break;
        }
      }

      adjustBlockchains(widget.rateModel);

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
        print("${item1.withdraw!.toLowerCase()}#1");
        for (BlockchainModel item2 in blockchains!) {
          if (item1.withdraw!
              .toLowerCase()
              .contains(item2.blockchain!.toLowerCase())) {
            print("${item2.blockchain!.toLowerCase()}#2");
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
            validator: _totalValidator.call,
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
        methods == null
            ? Container()
            : Container(
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
                              .map<DropdownMenuItem<PaymentMethodModel>>(
                                  (value) {
                            return DropdownMenuItem<PaymentMethodModel>(
                              value: value,
                              child: Row(
                                children: [
                                  Image.network(
                                    value.image ?? '',
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(value.metode ?? 'Nama Kosong'),
                                ],
                              ),
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
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
        title: Text("Withdraw ${widget.rateModel.name}"),
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
                buildBottom(),
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
                          if (_formKey.currentState!.validate()) {
                            // if ((selectedRate!.name!.toLowerCase() ==
                            //             "paypal" ||
                            //         selectedRate!.name!.toLowerCase() ==
                            //             "skrill" ||
                            //         selectedRate!.name!.toLowerCase() ==
                            //             "neteller") &&
                            //     !CommonMethods()
                            //         .isEmail(fieldController.text)) {
                            //   CommonDialog.buildOkDialog(
                            //       context, false, "Harap isi email yang valid");
                            // } else {
                            if (selectedRate!.categories!.toLowerCase() ==
                                    "crypto" &&
                                selectedChain == null) {
                              CommonDialog.buildOkDialog(context, false,
                                  "Harap pilih blockchain terlebih dahulu");
                            } else {
                              if (int.parse(totalController.text.trim()) == 0) {
                                CommonDialog.buildOkDialog(context, false,
                                    "Jumlah harus lebih dari 0");
                              } else {
                                if (selectedMethod == null) {
                                  CommonDialog.buildOkDialog(context, false,
                                      "Harap pilih metode pencairan terlebih dahulu");
                                } else {
                                  if (norekController.text.trim().isEmpty) {
                                    CommonDialog.buildOkDialog(context, false,
                                        "Harap isi nomor rekening atau e-wallet tujuan.");
                                  } else {
                                    if (selectedChain != null) {
                                      for (WithdrawModel item2 in withdraws) {
                                        if (item2.withdraw!
                                                .toLowerCase()
                                                .contains(selectedChain!
                                                    .blockchain!
                                                    .toLowerCase()) &&
                                            item2.withdraw!
                                                .toLowerCase()
                                                .contains(selectedRate!.name!
                                                    .toLowerCase())) {
                                          setState(() {
                                            selectedWithdraw = item2;
                                          });

                                          break;
                                        }
                                      }
                                    } else {
                                      for (WithdrawModel item2 in withdraws) {
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
                                      "blockchain_name": selectedChain == null
                                          ? null
                                          : selectedChain!.blockchain,
                                      "m_metode_id": selectedMethod!.id!,
                                    };

                                    RateModel chosenRate = selectedRate!;
                                    WithdrawModel chosenWd = selectedWithdraw!;
                                    BlockchainModel? chosenbc = selectedChain;

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
                                        wdSource: "alt",
                                      ),
                                      withNavBar: false,
                                    );
                                  }
                                }
                              }
                              //}
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
