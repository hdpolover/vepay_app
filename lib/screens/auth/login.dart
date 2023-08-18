import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/common/global_values.dart';
import 'package:vepay_app/screens/auth/forgot_password.dart';
import 'package:vepay_app/screens/auth/register.dart';
import 'package:vepay_app/screens/dashboard.dart';

import '../../models/member_model.dart';
import '../../resources/color_manager.dart';
import '../../services/auth_service.dart';
import '../../services/fb_service.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

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

  regist(String e, String n, String p, bool isGoogle) async {
    Map<String, dynamic> data;
    if (isGoogle) {
      data = {
        'is_google': true,
        "email": e,
        'mama': n,
      };
    } else {
      data = {
        'is_google': false,
        "email": e,
        "nama": n,
        "phone": "08",
        "password": p,
      };
    }

    try {
      MemberModel m = await AuthService().register(data);

      setState(() {
        isLoading = false;
      });

      if (isGoogle) {
        try {
          Map<String, dynamic> data = {
            "is_google": true,
            "email": m.email,
          };

          try {
            MemberModel m = await AuthService().login(data);

            CommonMethods().saveUserLoginsDetails(
                m.userId!, m.name!, m.email!, "", true, true);

            setState(() {
              isLoading = false;
            });

            currentMemberGlobal.value = m;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  member: currentMemberGlobal.value,
                ),
              ),
            );
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            CommonDialog.buildOkDialog(context, false, e.toString());
          }
        } catch (e) {
          Navigator.of(context).pop();

          setState(() {
            isLoading = false;
          });

          CommonDialog.buildOkDialog(
              context, false, "Terjadi kesalahan. Coba lagi.");
        }
      } else {
        setState(() {
          isLoading = false;
        });

        CommonDialog.buildOkRegister(context, true,
            "Pendaftaran berhasil. Silakan cek email untuk verifikasi lalu lakukan login.");
      }
    } catch (e) {
      FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();

      setState(() {
        isLoading = false;
      });

      CommonDialog.buildOkDialog(context, false, e.toString());
    }
  }

  login() async {
    Map<String, dynamic> data = {
      "is_google": false,
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      MemberModel m = await AuthService().login(data);

      CommonMethods().saveUserLoginsDetails(m.userId!, m.name!, m.email!,
          passwordController.text.trim(), true, false);

      setState(() {
        isLoading = false;
      });

      currentMemberGlobal.value = m;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            member: currentMemberGlobal.value,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      CommonDialog.buildOkDialog(context, false, e.toString());
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
        title: const Text("Masuk"),
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
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Row(
                  //     children: [
                  //       Transform.scale(
                  //         scale: 1.5,
                  //         child: Checkbox(
                  //           checkColor: Colors.white,
                  //           activeColor: ColorManager.primary,
                  //           value: checkValue,
                  //           side: BorderSide(
                  //             color: ColorManager.primary,
                  //             width: 2,
                  //           ),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               checkValue = value!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(width: 5),
                  //       //       Expanded(
                  //       //         child: GestureDetector(
                  //       //           onTap: () {
                  //       //             Navigator.push(
                  //       //               context,
                  //       //               MaterialPageRoute(
                  //       //                 builder: (context) => WebViewPage(
                  //       //                   title: "ToS dan Privacy Policy",
                  //       //                   url: "",
                  //       //                 ),
                  //       //               ),
                  //       //             );
                  //       //           },
                  //       //           child: RichText(
                  //       //             text: TextSpan(
                  //       //               children: [
                  //       //                 const TextSpan(
                  //       //                   text:
                  //       //                       'Dengan mendaftar, Anda telah menyetujui ',
                  //       //                   style: TextStyle(
                  //       //                     color: Colors.black,
                  //       //                   ),
                  //       //                 ),
                  //       //                 TextSpan(
                  //       //                   text: 'Terms of Service and Privacy Policy',
                  //       //                   style: TextStyle(
                  //       //                     color: ColorManager.primary,
                  //       //                   ),
                  //       //                 ),
                  //       //               ],
                  //       //             ),
                  //       //           ),
                  //       //         ),
                  //       //       ),
                  //       //     ],
                  //       //   ),
                  //       // ),
                  //       // const SizedBox(height: 20),
                  //     ],
                  //   ),
                  // ),
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
                              child: const Text('Masuk'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  login();
                                }
                              },
                            ),
                          ),
                        ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      );
                    },
                    child: Text(
                      'Lupa pasword?',
                      style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Belum memiliki akun? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Daftar',
                              style: TextStyle(
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("atau"),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                    child: SizedBox(
                      height: h * 0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.2,
                          backgroundColor: Colors.white, // background
                          foregroundColor: ColorManager.primary, // foreground
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              width: 30,
                              image: AssetImage('assets/google.png'),
                            ),
                            Text(
                              '   Masuk dengan Google',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          showDialog(
                              // The user CANNOT close this dialog  by pressing outsite it
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  // The background color
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // The loading indicator
                                        CircularProgressIndicator(
                                          color: ColorManager.primary,
                                        ),
                                        const SizedBox(height: 15),
                                        const Text("Menyambungkan")
                                      ],
                                    ),
                                  ),
                                );
                              });

                          try {
                            UserCredential? result =
                                await FbService.signInWithGoogle();

                            print(result.additionalUserInfo!.isNewUser);

                            if (result.additionalUserInfo!.isNewUser) {
                              // Close the dialog programmatically
                              Navigator.of(context).pop();

                              regist(
                                result.user!.email!,
                                result.user!.displayName!,
                                "",
                                true,
                              );
                            } else {
                              try {
                                Map<String, dynamic> data = {
                                  "is_google": true,
                                  "email": result.user!.email!,
                                };

                                try {
                                  MemberModel m =
                                      await AuthService().login(data);

                                  CommonMethods().saveUserLoginsDetails(
                                      m.userId!,
                                      m.email!,
                                      m.email!,
                                      "",
                                      true,
                                      true);

                                  setState(() {
                                    isLoading = false;
                                  });

                                  currentMemberGlobal.value = m;

                                  Navigator.of(context).pop();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Dashboard(
                                        member: currentMemberGlobal.value,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  CommonDialog.buildOkDialog(
                                      context, false, e.toString());
                                }
                              } catch (e) {
                                Navigator.of(context).pop();

                                setState(() {
                                  isLoading = false;
                                });

                                CommonDialog.buildOkDialog(
                                    context, false, e.toString());
                              }
                            }
                          } catch (e) {
                            Navigator.of(context).pop();

                            setState(() {
                              isLoading = false;
                            });

                            CommonDialog.buildOkDialog(
                                context, false, e.toString());
                          }
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
