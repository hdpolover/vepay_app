import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/global_values.dart';
import 'package:vepay_app/screens/auth/login.dart';
import 'package:vepay_app/screens/auth/register.dart';
import 'package:vepay_app/services/app_info_service.dart';

import '../../models/referral_info_model.dart';
import '../../resources/color_manager.dart';
import '../../services/referral_service.dart';
import '../dashboard.dart';

class Referral extends StatefulWidget {
  Referral({Key? key}) : super(key: key);

  @override
  State<Referral> createState() => _ReferralState();
}

class _ReferralState extends State<Referral> {
  ReferralInfoModel? referralInfoModel;

  TextEditingController kodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isKodeOk = false;
  bool _isLoading = false;

  final _kodeValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan kode referral'),
  ]);

  getMyInfo() async {
    try {
      referralInfoModel = await ReferralService().getReferralInfo();

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

  saveReferral() async {
    try {
      String a =
          await ReferralService().setReferral(kodeController.text.trim());

      setState(() {
        _isLoading = false;
      });

      CommonDialog.buildOkReferralDialog(context, true, a);
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 2 * 0.1, vertical: h * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FancyShimmerImage(
                    boxFit: BoxFit.cover,
                    height: h * 0.25,
                    width: w * 0.5,
                    imageUrl: referralInfoModel == null
                        ? "-"
                        : referralInfoModel!.image!,
                    errorWidget: Image.network(
                        'https://vectorified.com/images/user-icon-1.png'),
                  ),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                    child: Text(
                      referralInfoModel == null
                          ? "-"
                          : referralInfoModel!.titleReferralIntro!,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: Text(
                      referralInfoModel == null
                          ? "-"
                          : AppInfoService().removeHtmlTags(
                              referralInfoModel!.descReferralIntro!),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.1,
                  ),
                  _isKodeOk
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: kodeController,
                                validator: _kodeValidator,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Kode referral',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                    child: SizedBox(
                      height: h * 0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary, // background
                          foregroundColor: Colors.white, // foreground
                        ),
                        child: _isKodeOk
                            ? _isLoading
                                ? const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Simpan')
                            : const Text('Saya punya Kode Referral'),
                        onPressed: () async {
                          if (_isKodeOk) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              saveReferral();
                            }
                          } else {
                            setState(() {
                              _isKodeOk = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                    child: SizedBox(
                      height: h * 0.06,
                      width: double.infinity,
                      child: TextButton(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.white54, // background
                        //   foregroundColor: ColorManager.primary, // foreground
                        // ),
                        child: const Text(
                          'Lain kali',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(
                                member: currentMemberGlobal.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
