import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/global_values.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/screens/auth/login.dart';
import 'package:vepay_app/screens/auth/referral.dart';
import 'package:vepay_app/screens/dashboard.dart';
import 'package:vepay_app/screens/webview_page.dart';
import 'package:vepay_app/services/auth_service.dart';

import '../../common/common_method.dart';
import '../../resources/color_manager.dart';
import '../../services/fb_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

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
    MinLengthValidator(9,
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

  regist(String e, String n, String p, String phone, bool isGoogle,
      String fcmToken) async {
    Map<String, dynamic> data;
    if (isGoogle) {
      data = {
        'is_google': true,
        "email": e,
        'nama': n,
        'phone': phone,
        'fcm_token': fcmToken,
      };
    } else {
      data = {
        'is_google': false,
        "email": e,
        "nama": n,
        "phone": phone,
        "password": p,
        'fcm_token': fcmToken,
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
                m.userId!, m.name!, m.email!, "", true, true, fcmToken);

            setState(() {
              isLoading = false;
            });

            currentMemberGlobal.value = m;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Referral(),
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
      //FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();

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
                        prefix: const Text("+62"),
                        border: const OutlineInputBorder(),
                        hintText: 'Nomor Telepon (WhatsApp)',
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
                                    url: "https://vepay.id/privacy-policy/",
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

                                    var prefs = SharedPreferences.getInstance();

                                    String fcmToken = await prefs.then(
                                        (value) =>
                                            value.getString("fcmToken") ?? "");

                                    try {
                                      int? res = await AuthService().checkEmail(
                                          emailController.text
                                              .trim()
                                              .toString());

                                      print(res);

                                      if (res == 0) {
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                          );

                                          regist(
                                            emailController.text.trim(),
                                            nameController.text.trim(),
                                            passwordController.text.trim(),
                                            phoneController.text.trim(),
                                            false,
                                            fcmToken,
                                          );
                                        } catch (e) {
                                          setState(() {
                                            isLoading = false;
                                          });

                                          String message = e.toString();

                                          CommonDialog.buildOkDialog(context,
                                              false, message.split("]").last);
                                        }
                                      } else if (res == 1) {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        FbService.signOut(context);

                                        CommonDialog.buildOkDialog(
                                            context,
                                            false,
                                            "Akun Anda dibanned, silahkan hubungi admin untuk informasi lebih lanjut.");
                                      } else if (res == 2) {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        CommonDialog.buildOkDialog(
                                            context,
                                            false,
                                            "Email sudah terdaftar. Silakan lakukan login.");
                                      }
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      CommonDialog.buildOkDialog(
                                          context, false, e.toString());
                                    }
                                  }
                                }
                              },
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
                              '   Daftar dengan Google',
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

                            var prefs = SharedPreferences.getInstance();

                            String fcmToken = await prefs.then(
                                (value) => value.getString("fcmToken") ?? "");

                            if (result.additionalUserInfo!.isNewUser) {
                              // Close the dialog programmatically
                              Navigator.of(context).pop();

                              regist(
                                result.user!.email!,
                                result.user!.displayName!,
                                "",
                                "8123",
                                true,
                                fcmToken,
                              );
                            } else {
                              int? res = await AuthService()
                                  .checkEmail(result.user!.email!);

                              print(res);

                              if (res == 0) {
                                regist(
                                  result.user!.email!,
                                  result.user!.displayName!,
                                  "",
                                  "8123",
                                  true,
                                  fcmToken,
                                );
                              } else if (res == 1) {
                                FbService.signOut(context);

                                Navigator.of(context).pop();

                                setState(() {
                                  isLoading = false;
                                });

                                CommonDialog.buildOkDialog(context, false,
                                    "Akun Anda dibanned, silahkan hubungi admin untuk informasi lebih lanjut.");
                              } else if (res == 2) {
                                try {
                                  Map<String, dynamic> data = {
                                    "is_google": true,
                                    "email": result.user!.email!,
                                    "fcm_token": fcmToken,
                                  };

                                  try {
                                    MemberModel m =
                                        await AuthService().login(data);

                                    CommonMethods().saveUserLoginsDetails(
                                      m.userId!,
                                      m.name!,
                                      m.email!,
                                      "",
                                      true,
                                      true,
                                      fcmToken,
                                    );

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
                                    Navigator.of(context).pop();

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
                            }
                          } catch (e) {
                            Navigator.of(context).pop();

                            setState(() {
                              isLoading = false;
                            });

                            // CommonDialog.buildOkDialog(
                            //     context, false, e.toString());
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
                                fontWeight: FontWeight.bold,
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
