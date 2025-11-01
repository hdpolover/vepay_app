import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/resources/text_style_manager.dart';
import 'package:vepay_app/screens/auth/check_email.dart';

import '../../resources/color_manager.dart';
import '../../services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan email'),
    EmailValidator(errorText: "Harap masukan email yang valid")
  ]);

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      bool? isSent =
          await AuthService().resetPassword(emailController.text.trim());

      setState(() {
        isLoading = false;
      });

      if (isSent) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckEmail(
              email: emailController.text.trim(),
            ),
          ),
        );
      } else {
        CommonDialog.buildOkDialog(context, false,
            "Tidak dapat menemukan akun dengan email tersebut.");
      }
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Lupa Password"),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Jangan Khawatir!\nMasukkan email Anda, dan kami akan mengirimkan link untuk mengubah password.",
                textAlign: TextAlign.justify,
                style: TextStyleManager.instance.body18,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: _emailValidator,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Email",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorManager.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? CircularProgressIndicator(
                      color: ColorManager.primary,
                    )
                  : SizedBox(
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
                            setState(() {
                              isLoading = true;
                            });

                            resetPassword();
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      )),
    );
  }
}
