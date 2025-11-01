import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/payment_method_model.dart';

import '../../common/common_method.dart';
import '../../models/my_referral_model.dart';
import '../../models/referral_info_model.dart';
import '../../resources/color_manager.dart';
import '../../services/app_info_service.dart';
import '../../services/payment_method_service.dart';
import '../../services/referral_service.dart';

class WithdrawCashbackReferral extends StatefulWidget {
  MyReferralModel? myReferralModel;
  ReferralInfoModel? referralInfoModel;

  WithdrawCashbackReferral(
      {required this.myReferralModel,
      required this.referralInfoModel,
      Key? key})
      : super(key: key);

  @override
  State<WithdrawCashbackReferral> createState() =>
      _WithdrawCashbackReferralState();
}

class _WithdrawCashbackReferralState extends State<WithdrawCashbackReferral> {
  List<PaymentMethodModel>? methods;
  PaymentMethodModel? selectedMethod;

  TextEditingController nominalController = TextEditingController();
  TextEditingController rekTujuanController = TextEditingController();
  TextEditingController atasNamaController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    getMethodts();
    super.initState();
  }

  getMethodts() async {
    methods = await PaymentMethodService().getMethods();

    setState(() {});
  }

  withdraw() async {
    if (widget.myReferralModel!.saldoReferral! >
        int.parse(nominalController.text.toString())) {
      if (int.parse(nominalController.text.toString()) <
          widget.referralInfoModel!.referralWithdrawMinimum!) {
        CommonDialog.buildOkDialog(context, false,
            "Minimal nominal withdraw cashback adalah ${CommonMethods.formatCompleteCurrency(double.parse(widget.referralInfoModel!.referralWithdrawMinimum!.toString()))}");
      } else {
        if (int.parse(nominalController.text.toString()) == 0) {
          CommonDialog.buildOkDialog(
              context, false, "Tidak dapat withdraw dengan nominal 0");
        } else {
          if (selectedMethod == null) {
            CommonDialog.buildOkDialog(context, false,
                "Silakan pilih metode pencairan cashback terlebih dahulu");
          } else {
            setState(() {
              isLoading = true;
            });

            try {
              Map<String, dynamic> data = {
                'nominal': nominalController.text.trim(),
                'rekening_tujuan': rekTujuanController.text.trim(),
                'atas_nama': atasNamaController.text.trim(),
                'metode': selectedMethod!.id!,
              };

              await ReferralService().withdraw(data).then((value) {
                setState(() {
                  isLoading = false;
                });

                CommonDialog.buildOkWithdrawCashbackDialog(
                    context,
                    true,
                    "Berhasil melalukan withdraw cashback. Mohon tunggu proses withdraw oleh Admin.",
                    widget.referralInfoModel!);
              });
            } catch (e) {
              setState(() {
                isLoading = false;
              });
              CommonDialog.buildOkDialog(context, false, e.toString());
            }
          }
        }
      }
    } else {
      CommonDialog.buildOkDialog(context, false,
          "Nominal withdraw cashback tidak bisa lebih besar dari saldo cashback Anda");
    }
  }

  buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Withdraw Cashback',
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: nominalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Nominal Withdraw",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                          child: Row(
                            children: [
                              Image.network(
                                value.image ?? '',
                                errorBuilder: (context, error, stackTrace) =>
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
          const SizedBox(height: 10),
          selectedMethod == null
              ? Container()
              : TextFormField(
                  controller: rekTujuanController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Nomor Rekening Tujuan",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          selectedMethod == null
              ? Container()
              : TextFormField(
                  controller: atasNamaController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Atas Nama",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          (nominalController.text.isEmpty &&
                  atasNamaController.text.isEmpty &&
                  rekTujuanController.text.isEmpty)
              ? Container()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    onPressed: isLoading
                        ? () {}
                        : () {
                            withdraw();
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Withdraw Cashback Referral"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            color: ColorManager.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    "Saldo Cashback",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    CommonMethods.formatCompleteCurrency(
                      double.parse(
                          widget.myReferralModel!.saldoReferral!.toString()),
                    ),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppInfoService().removeHtmlTags(
                          widget.referralInfoModel!.referralDescInfo!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          methods == null ? Container() : buildInput(),
          const SizedBox(height: 20),
        ],
      )),
    );
  }
}
