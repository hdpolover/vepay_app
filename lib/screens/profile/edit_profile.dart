import 'dart:convert';
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/services/auth_service.dart';

import '../../models/member_model.dart';

class EditProfile extends StatefulWidget {
  MemberModel member;
  EditProfile({required this.member, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? birthController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? addressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  XFile? _imageFile;

  bool _isLoading = false;

  DateTime? _selectedDate;
  String? birthDateValue;

  var _result;

  final _nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan nama'),
  ]);

  final _phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan nomor telepon'),
    MinLengthValidator(9,
        errorText: "Panjang nomor telepon minimal 10 karakter"),
    MaxLengthValidator(15,
        errorText: "Panjang nomor telepon maksimal 15 karakter"),
  ]);

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan email'),
  ]);

  final _addressValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap masukan alamat'),
  ]);

  final _birthDateValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap pilih tanggal lahir'),
  ]);

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void showPickImageDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Pilih gambar dari",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);

                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const FaIcon(
                                    FontAwesomeIcons.camera,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('Kamera',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);

                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const FaIcon(
                                    FontAwesomeIcons.image,
                                    size: 35,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Galeri',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValues();

    super.initState();
  }

  _initValues() {
    setState(() {
      nameController!.text = widget.member.name ?? "";
      addressController!.text = widget.member.address ?? "";
      emailController!.text = widget.member.email ?? "";
      birthController!.text = widget.member.birthdate ?? "";
      phoneController!.text = widget.member.phone ?? "";
      _result = widget.member.gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Edit Profil"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Center(
                    child: SizedBox(
                      height: 129,
                      width: 140,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0), //or 15.0
                            child: SizedBox(
                              height: 120.0,
                              width: 120.0,
                              child: _imageFile == null
                                  ? SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FancyShimmerImage(
                                          boxFit: BoxFit.cover,
                                          imageUrl: widget.member.photo ??
                                              "https://vectorified.com/images/user-icon-1.png",
                                          errorWidget: Image.network(
                                              'https://vectorified.com/images/user-icon-1.png'),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned.fill(
                            top: 10,
                            right: 10,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  //_displayPickImageDialog(context);
                                  showPickImageDialog(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 17),
                                  height: 55,
                                  width: 55,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.camera_alt),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Text("Nama", style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                      height: 15, width: MediaQuery.of(context).size.width),
                  TextFormField(
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
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Text("Jenis Kelamin",
                      style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(height: 5, width: MediaQuery.of(context).size.width),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10),
                            title: const Text('Laki-laki'),
                            value: "laki-laki",
                            groupValue: _result,
                            dense: true,
                            onChanged: (value) {
                              setState(() {
                                _result = value;
                              });
                            }),
                      ),
                      Expanded(
                        child: RadioListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10),
                            title: const Text('Perempuan'),
                            value: "perempuan",
                            groupValue: _result,
                            dense: true,
                            onChanged: (value) {
                              setState(() {
                                _result = value;
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Text("Tanggal Lahir",
                      style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                      height: 15, width: MediaQuery.of(context).size.width),
                  TextFormField(
                    controller: birthController,
                    validator: _birthDateValidator,
                    readOnly: true,
                    onTap: () {
                      displayDatePicker();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Tanggal Lahir',
                      suffixIcon: const Icon(Icons.calendar_month),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Text("Email", style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                      height: 15, width: MediaQuery.of(context).size.width),
                  TextFormField(
                    controller: emailController,
                    validator: _emailValidator,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
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
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Text("Alamat", style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                      height: 15, width: MediaQuery.of(context).size.width),
                  TextFormField(
                    controller: addressController,
                    validator: _addressValidator,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Alamat',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 13, width: MediaQuery.of(context).size.width),
                  Text("Nomor Telepon",
                      style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(
                      height: 15, width: MediaQuery.of(context).size.width),
                  TextFormField(
                    controller: phoneController,
                    validator: _phoneValidator,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Nomor Telepon (WhatsApp)',
                      prefix: const Text("+62",
                          style: TextStyle(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 30, width: MediaQuery.of(context).size.width),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary, // background
                            foregroundColor: Colors.white, // foreground
                          ),
                          child: const Text('Simpan'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_result == null) {
                                CommonDialog.buildOkDialog(context, false,
                                    "Silakan pilih jenis kelamin");
                              } else {
                                if (_selectedDate == null &&
                                    birthController!.text.isEmpty) {
                                  CommonDialog.buildOkDialog(context, false,
                                      "Silakan pilih tanggal lahir");
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  simpanData();
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  simpanData() async {
    if (_imageFile == null) {
      Map<String, dynamic> data = {
        'user_id': widget.member.userId,
        'name': nameController!.text.trim(),
        'gender': _result,
        'birthdate': birthController!.text.trim(),
        'phone': phoneController!.text.trim(),
        'address': addressController!.text.trim(),
      };

      try {
        bool res = await AuthService().updateDetail(data);

        if (res) {
          setState(() {
            _isLoading = false;
          });

          CommonDialog.buildOkUpdateDialog(context, true,
              "Berhasil memperbarui profil. Silakan refresh halaman.");
        } else {
          setState(() {
            _isLoading = false;
          });

          CommonDialog.buildOkDialog(
              context, false, "Terjadi kesalahan. Coba lagi.");
        }
      } catch (e) {
        CommonDialog.buildOkDialog(context, false, e.toString());
      }
    } else {
      setState(() {
        _isLoading = true;
      });

      final bytes = File(_imageFile!.path).readAsBytesSync();

      String img64 = base64Encode(bytes);

      print(img64);

      Map<String, dynamic> data = {
        'user_id': widget.member.userId,
        'photo': "data:image/jpeg;base64,$img64",
      };

      try {
        bool p = await AuthService().updateFoto(data);

        if (p) {
          Map<String, dynamic> data = {
            'user_id': widget.member.userId,
            'name': nameController!.text.trim(),
            'gender': _result,
            'birthdate': birthController!.text.trim(),
            'phone': phoneController!.text.trim(),
            'address': addressController!.text.trim(),
          };

          try {
            bool res = await AuthService().updateDetail(data);

            if (res) {
              setState(() {
                _isLoading = false;
              });

              CommonDialog.buildOkDialog(
                  context, true, "Berhasil memperbarui profil.");
            } else {
              setState(() {
                _isLoading = false;
              });

              CommonDialog.buildOkDialog(
                  context, false, "Terjadi kesalahan. Coba lagi.");
            }
          } catch (e) {
            CommonDialog.buildOkDialog(context, false, e.toString());
          }
        } else {
          setState(() {
            _isLoading = false;
          });

          CommonDialog.buildOkDialog(
              context, false, "Terjadi kesalahan. Coba lagi.");
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        CommonDialog.buildOkDialog(context, false,
            "Terjadi kesalahan saat mengunggah foto. Coba lagi.");
      }
    }
  }

  displayDatePicker() {
    showDatePicker(
        context: context,
        // Coba kita set initialDate ke tanggal yang sudah ada jika ada
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1950, 1, 1),
        lastDate: DateTime(3000, 1, 1),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              // 1. Menggunakan ColorScheme.light untuk styling yang lebih modern & lengkap
              colorScheme: ColorScheme.light(
                // Warna utama (latar belakang header, tanggal terpilih)
                primary: ColorManager.primary,
                // Teks di atas warna utama (teks di header, teks tanggal terpilih)
                onPrimary: Colors.white,
                // Teks lain (nama bulan, hari, tanggal tidak terpilih)
                // INI PENTING: Juga mengatur warna teks untuk input manual
                onSurface: Colors.black,
                // Latar belakang dialog
                surface: Colors.white,
              ),

              // 2. Menyesuaikan warna tombol OK/Cancel
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.primary, // Warna teks tombol
                ),
              ),

              // 3. Mengatur warna latar belakang dialog secara eksplisit
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        }).then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }

      setState(() {
        // using state so that the UI will be rerendered when date is picked
        _selectedDate = pickedDate;
        birthController!.text = DateFormat.yMMMMd('id').format(_selectedDate!);

        birthDateValue = DateFormat('dd-MM-yyyy').format(_selectedDate!);
      });
    });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
