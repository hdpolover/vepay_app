import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/models/vcc_model.dart';

import '../../common/common_widgets.dart';
import '../../resources/color_manager.dart';
import '../home/product_buy_detail.dart';

class TopupVcc extends StatefulWidget {
  VccModel vccModel;
  TopupVcc({required this.vccModel, Key? key}) : super(key: key);

  @override
  State<TopupVcc> createState() => _TopupVccState();
}

class _TopupVccState extends State<TopupVcc> {
  TextEditingController vccNoController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController fieldController = TextEditingController();

  final _totalValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan jumlah'),
  ]);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setData();
  }

  setData() {
    setState(() {
      vccNoController.text = widget.vccModel.number!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Topup VCC"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: vccNoController,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                    int.parse(totalController.text.trim()) ==
                                        0) {
                                  CommonDialog.buildOkDialog(context, false,
                                      "Jumlah harus lebih dari 0");

                                  totalController.text = 1.toString();
                                } else {
                                  setState(() {
                                    int total =
                                        int.parse(totalController.text) - 1;
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),
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
                                  int total =
                                      int.parse(totalController.text) + 1;
                                  totalController.text = total.toString();
                                }
                              },
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            if (int.parse(totalController.text.trim()) == 0) {
                              CommonDialog.buildOkDialog(
                                  context, false, "Jumlah harus lebih dari 0");
                            } else {
                              Map<String, dynamic> data = {
                                "akun_tujuan": fieldController.text.trim(),
                                "jumlah": totalController.text.trim(),
                                "blockchain_id": null,
                                "blockchain_name": null,
                              };

                              // PersistentNavBarNavigator.pushNewScreen(
                              //   context,
                              //   screen: ProductBuyDetail(
                              //     rateModel: 17,
                              //     data: data,
                              //   ),
                              //   withNavBar: false,
                              // );
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
