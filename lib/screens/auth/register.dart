import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/screens/auth/login.dart';
import 'package:vepay_app/screens/dashboard.dart';
import 'package:vepay_app/screens/webview_page.dart';
import 'package:vepay_app/services/auth_service.dart';

import '../../resources/color_manager.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

  final _nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan nama'),
    MinLengthValidator(3, errorText: "Panjang nama minimal 3 karakter"),
  ]);

  final _phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan nomor telepon'),
    MinLengthValidator(10,
        errorText: "Panjang nomor telepon minimal 10 karakter"),
    MaxLengthValidator(15,
        errorText: "Panjang nomor telepon maksimal 15 karakter"),
  ]);

  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: "Harap masukan password"),
    MinLengthValidator(8, errorText: "Panjang password minimal 8 karakter"),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: "Password harus menyertakan karakter special"),
  ]);

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan email'),
    EmailValidator(errorText: "Harap masukan email yang valid")
  ]);

  bool checkValue = false;

  regist() async {
    Map<String, dynamic> data = {
      "email": emailController.text.trim(),
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      MemberModel m = await AuthService().register(data);

      setState(() {
        isLoading = false;
      });

      CommonDialog.buildOkRegister(context, true,
          "Pendaftaran berhasil. Silakan cek email untuk verifikasi lalu lakukan login.");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CommonDialog.buildOkDialog(
          context, false, "Terjadi kesalahan. Coba lagi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Daftar"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: nameController,
                      validator: _nameValidator,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Nama',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: phoneController,
                      validator: _phoneValidator,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Telepon',
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
                      controller: passwordController,
                      validator: _passwordValidator,
                      keyboardType: TextInputType.text,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorManager.primary,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                _isObscure ? Colors.grey : ColorManager.primary,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _isObscure = !_isObscure;
                              },
                            );
                          },
                          splashRadius: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      validator: (val) => MatchValidator(
                              errorText: "Konfirmasi password tidak sama")
                          .validateMatch(val!, passwordController.text),
                      keyboardType: TextInputType.text,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Konfirmasi Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorManager.primary,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                _isObscure ? Colors.grey : ColorManager.primary,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _isObscure = !_isObscure;
                              },
                            );
                          },
                          splashRadius: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: ColorManager.primary,
                            value: checkValue,
                            side: BorderSide(
                              color: ColorManager.primary,
                              width: 2,
                            ),
                            onChanged: (value) {
                              setState(() {
                                checkValue = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewPage(
                                    title: "ToS dan Privacy Policy",
                                    url: "",
                                  ),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text:
                                        'Dengan mendaftar, Anda telah menyetujui ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service and Privacy Policy',
                                    style: TextStyle(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator(
                          color: ColorManager.primary,
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                          child: SizedBox(
                            height: h * 0.06,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorManager.primary, // background
                                foregroundColor: Colors.white, // foreground
                              ),
                              child: const Text('Daftar'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (!checkValue) {
                                    CommonDialog.buildOkDialog(context, false,
                                        "Harap setuju dengan ToS and Privacy Policy.");
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    regist();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Sudah memiliki akun? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Masuk',
                              style: TextStyle(
                                color: ColorManager.primary,
                              ),
                            ),
                          ],
                        ),
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
