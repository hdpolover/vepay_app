import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/my_referral_model.dart';
import 'package:vepay_app/models/referral_info_model.dart';
import 'package:vepay_app/models/referred_friend_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/referral/daftar_teman.dart';
import 'package:vepay_app/screens/referral/riwayat_referral.dart';
import 'package:vepay_app/screens/referral/withdraw_cashback_referral.dart';
import 'package:vepay_app/services/referral_service.dart';
import 'package:html/parser.dart';

import '../../common/common_method.dart';
import '../../services/app_info_service.dart';

class ReferralHome extends StatefulWidget {
  ReferralHome({Key? key}) : super(key: key);

  @override
  State<ReferralHome> createState() => _ReferralHomeState();
}

class _ReferralHomeState extends State<ReferralHome> {
  MyReferralModel? myReferralModel;
  ReferralInfoModel? referralInfoModel;
  List<ReferredFriendModel> refFriends = [];

  TextEditingController kodeController = TextEditingController();
  TextEditingController inputKodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isNotEditing = true;
  bool _isSaving = false;
  bool _isLoading = false;
  bool _isInputKode = false;

  final _kodeValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan kode referral'),
  ]);

  getMyInfo() async {
    try {
      referralInfoModel = await ReferralService().getReferralInfo();
      myReferralModel = await ReferralService().getMyReferral();
      refFriends = await ReferralService().getFriends();

      kodeController.text = myReferralModel!.kodeReferral!.toUpperCase();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getMyInfo();
    super.initState();
  }

  saveReferralKode() async {
    try {
      bool res = await ReferralService()
          .updateKode(kodeController.text.trim().toUpperCase());

      if (res) {
        setState(() {
          _isSaving = false;
          _isNotEditing = true;
        });

        CommonDialog.buildOkDialog(
            context, true, "Berhasil mengubah kode referral.");
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      print(e);
      CommonDialog.buildOkDialog(context, false, e.toString());
    }
  }

  saveReferral() async {
    try {
      String a =
          await ReferralService().setReferral(inputKodeController.text.trim());

      setState(() {
        _isLoading = false;
        _isInputKode = false;
        referralInfoModel = null;
        myReferralModel = null;
      });

      getMyInfo();

      CommonDialog.buildOkDialog(context, true, a);
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());

      setState(() {
        _isLoading = false;
      });
    }
  }

  buildHeader() {
    return referralInfoModel == null
        ? Container()
        : Container(
            width: double.infinity,
            color: ColorManager.primary,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                FancyShimmerImage(
                  boxFit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.5,
                  imageUrl: referralInfoModel!.image!,
                  errorWidget: Image.network(
                      'https://vectorified.com/images/user-icon-1.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  referralInfoModel!.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  AppInfoService()
                      .removeHtmlTags(referralInfoModel!.description!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          );
  }

  buildKode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Kode referralmu",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          TextFormField(
            readOnly: _isNotEditing,
            controller: kodeController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              fillColor: ColorManager.primary.withOpacity(0.9),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.primary,
                  style: BorderStyle.none,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.primary,
                  style: BorderStyle.solid,
                ),
              ),
              suffixIcon: _isSaving
                  ? Container(
                      height: 5,
                      width: 5,
                      padding: const EdgeInsets.all(10),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : !_isNotEditing
                      ? IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSaving = true;
                            });

                            saveReferralKode();
                          },
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                        text: kodeController.text
                                            .trim()
                                            .toUpperCase()))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Berhasil menyalin text ke clipboard")));
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isNotEditing = false;
                                });
                              },
                            ),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 15),
          myReferralModel == null
              ? Container()
              : myReferralModel!.status == null
                  ? _isInputKode
                      ? buildInputReferral()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Punya kode referral teman?"),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isInputKode = true;
                                  });
                                },
                                child: const Text("Masukan di sini"))
                          ],
                        )
                  : Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Expanded(
                          child: Text(
                            myReferralModel!.status!,
                            style: const TextStyle(color: Colors.grey),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  buildInputReferral() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: inputKodeController,
              validator: _kodeValidator,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Kode referral teman',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Simpan'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        saveReferral();
                      }
                    },
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isInputKode = false;
                    });
                  },
                  icon: const Icon(Icons.close)),
            ],
          ),
        ),
      ],
    );
  }

  buildSaldo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: ColorManager.primary,
                  width: 7.0,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Saldo Cashback",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  myReferralModel == null
                      ? "-"
                      : CommonMethods.formatCompleteCurrency(
                          double.parse(
                              myReferralModel!.saldoReferral!.toString()),
                        ),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primary),
                ),
                myReferralModel == null || referralInfoModel == null
                    ? Container()
                    : referralInfoModel!.referralWithdrawMinimum! >
                            myReferralModel!.saldoReferral!
                        ? Container()
                        : const SizedBox(height: 20),
                myReferralModel == null || referralInfoModel == null
                    ? Container()
                    : referralInfoModel!.referralWithdrawMinimum! >
                            myReferralModel!.saldoReferral!
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.primary, // background
                                  foregroundColor: Colors.white, // foreground
                                ),
                                child: const Text('Withdraw Cashback'),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: WithdrawCashbackReferral(
                                      myReferralModel: myReferralModel,
                                      referralInfoModel: referralInfoModel,
                                    ),
                                    withNavBar: false,
                                  );
                                },
                              ),
                            ),
                          ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // child: Center(
                  //     child: HtmlWidget(
                  //   referralInfoModel!.referralDescInfo!,
                  //   renderMode: RenderMode.column,
                  // )),
                  child: Text(
                    referralInfoModel == null
                        ? "-"
                        : AppInfoService().removeHtmlTags(
                            referralInfoModel!.referralDescInfo!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: refFriends.isEmpty
                                    ? "0"
                                    : refFriends.length.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                              ),
                              const TextSpan(text: ' teman bergabung'),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: DaftarTeman(
                                friends: refFriends,
                                referralInfoModel: referralInfoModel!,
                              ),
                              withNavBar: false,
                            );
                          },
                          child: Text(
                            "Lihat",
                            style: TextStyle(color: ColorManager.primary),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      child: const Text('Riwayat Transaksi Referral'),
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: RiwayatReferral(
                            referralInfoModel: referralInfoModel,
                          ),
                          withNavBar: false,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          referralInfoModel == null
              ? Container()
              : HtmlWidget(referralInfoModel!.penggunaan!)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Referral"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildKode(),
            buildSaldo(),
            buildBottom(),
          ],
        ),
      ),
    );
  }
}
