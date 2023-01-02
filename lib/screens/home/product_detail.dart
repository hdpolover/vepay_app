import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/screens/home/product_buy_detail.dart';

import '../../resources/color_manager.dart';

class ProductDetail extends StatefulWidget {
  RateModel rateModel;
  ProductDetail({required this.rateModel, Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  TextEditingController emailController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan email'),
    EmailValidator(errorText: "Harap masukan email yang valid")
  ]);

  final _totalValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan jumlah'),
  ]);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar(widget.rateModel.name!),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  validator: _emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Email ${widget.rateModel.name}',
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
                                setState(() {
                                  int total =
                                      int.parse(totalController.text) - 1;
                                  totalController.text = total.toString();
                                });
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
                                int total = int.parse(totalController.text) + 1;
                                totalController.text = total.toString();
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
                            Map<String, dynamic> data = {
                              "email": emailController.text.trim(),
                              "jumlah": totalController.text.trim(),
                            };

                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: ProductBuyDetail(
                                rateModel: widget.rateModel,
                                data: data,
                              ),
                              withNavBar: false,
                            );
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
