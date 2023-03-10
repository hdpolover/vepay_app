import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/resources/color_manager.dart';

import '../../models/member_model.dart';

class EditProfile extends StatefulWidget {
  MemberModel member;
  EditProfile({required this.member, Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? lastNameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? companyController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  XFile? _imageFile;

  bool _isLoading = false;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 100,
        maxHeight: 100,
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
                      "Pick image from",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
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
                                  child: Text('Camera',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
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
                              Text('Gallery',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
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

  @override
  void initState() {
    _initValues();

    super.initState();
  }

  _initValues() {
    setState(() {
      // nameController!.text = widget.member.firstName!;
      // lastNameController!.text = widget.currentCustomer.lastName!;
      // emailController!.text = widget.currentCustomer.email!;
      // emailController!.text = widget.currentCustomer.email!;
      // phoneController!.text = widget.currentCustomer.phoneNumber;
      // companyController!.text = widget.currentCustomer.companyName;

      // currentUserCountry = widget.currentCustomer.country;
      // selectedCountry = currentUserCountry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Edit Profil"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13, width: MediaQuery.of(context).size.width),
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
                                        imageUrl: widget.member.photo,
                                        errorWidget: Image.network(
                                            'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
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
                SizedBox(height: 13, width: MediaQuery.of(context).size.width),
                Text("Nama", style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 15, width: MediaQuery.of(context).size.width),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 24, top: 3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'First Name',
                        border: InputBorder.none,
                        labelStyle: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                SizedBox(height: 13, width: MediaQuery.of(context).size.width),
                Text("Last Name", style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 15, width: MediaQuery.of(context).size.width),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 24, top: 3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: lastNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Last Name',
                        border: InputBorder.none,
                        labelStyle: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                SizedBox(height: 13, width: MediaQuery.of(context).size.width),
                Text("Email", style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 15, width: MediaQuery.of(context).size.width),
                Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 24, top: 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            border: InputBorder.none,
                            labelStyle:
                                Theme.of(context).textTheme.bodyText2))),
                SizedBox(height: 13, width: MediaQuery.of(context).size.width),
                // Text("Email", style: Theme.of(context).textTheme.subtitle2),
                // SizedBox(
                //     height: 15, width: MediaQuery.of(context).size.width),
                // Container(
                //     height: 55,
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.only(left: 24, top: 3),
                //     decoration: BoxDecoration(
                //         border: Border.all(color: CustomColors.colorGrey),
                //         borderRadius: BorderRadius.circular(5)),
                //     child: TextField(
                //         controller: emailController,
                //         keyboardType: TextInputType.emailAddress,
                //         decoration: InputDecoration(
                //             hintText: 'Email',
                //             border: InputBorder.none,
                //             labelStyle:
                //                 Theme.of(context).textTheme.bodyText2))),
                // SizedBox(
                //     height: 13, width: MediaQuery.of(context).size.width),

                SizedBox(height: 13, width: MediaQuery.of(context).size.width),
                Text("Associated Company",
                    style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 15, width: MediaQuery.of(context).size.width),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 24, top: 3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: companyController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Associated Company',
                        border: InputBorder.none,
                        labelStyle: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                SizedBox(height: 30, width: MediaQuery.of(context).size.width),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  )
                else
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: OutlinedButton(
                        child: const Text('Save'),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          // CustomerModel cust;

                          // if (_imageFile != null) {
                          //   String imageLink = await BlobUploadService()
                          //       .uploadProfileImageToAzure(
                          //           context, _imageFile!);

                          //   print(imageLink);

                          //   cust = CustomerModel(
                          //     id: widget.currentCustomer.id,
                          //     firstName: firstNameController!.text,
                          //     lastName: lastNameController!.text,
                          //     email: widget.currentCustomer.email,
                          //     userName: emailController!.text,
                          //     phoneNumber: justPhoneNumber,
                          //     companyName: companyController!.text,
                          //     profileImage: imageLink,
                          //     password:
                          //         currentAppUser.currentCustomer!.password,
                          //     userProperties:
                          //         widget.currentCustomer.userProperties,
                          //     country: selectedCountry,
                          //     userRoleId: widget.currentCustomer.userRoleId,
                          //     createTs: widget.currentCustomer.createTs,
                          //     language: widget.currentCustomer.language,
                          //     city: widget.currentCustomer.city,

                          //     //for now it will be set to bali time
                          //     //tzId: timezoneName,
                          //     tzId: "China Standard Time",
                          //     updateTs: DateTime.now().toIso8601String(),
                          //   );
                          // } else {
                          //   cust = CustomerModel(
                          //     id: currentAppUser.currentCustomer!.id,
                          //     firstName: firstNameController!.text,
                          //     lastName: lastNameController!.text,
                          //     email: widget.currentCustomer.email,
                          //     userName: emailController!.text,
                          //     phoneNumber: justPhoneNumber,
                          //     companyName: companyController!.text,
                          //     city: widget.currentCustomer.city,
                          //     language: widget.currentCustomer.language,
                          //     profileImage:
                          //         widget.currentCustomer.profileImage,
                          //     password:
                          //         currentAppUser.currentCustomer!.password,
                          //     userProperties:
                          //         widget.currentCustomer.userProperties,
                          //     country: selectedCountry,
                          //     userRoleId: widget.currentCustomer.userRoleId,
                          //     createTs: widget.currentCustomer.createTs,

                          //     //for now it will be set to bali time
                          //     //tzId: timezoneName,
                          //     tzId: "China Standard Time",
                          //     updateTs: DateTime.now().toIso8601String(),
                          //   );
                          // }

                          // var prefs = await SharedPreferences.getInstance();
                          // String? token = prefs.getString('token');

                          // var customer = await _customerApiService.updateUser(
                          //     cust, token!);

                          // setState(() {
                          //   _isLoading = false;
                          //   //currentAppUser.currentCustomer = customer;
                          // });

                          // if (customer == null) {
                          //   CommonDialogWidgets.buildOkDialog(context, false,
                          //       "Something went wrong. Try again!");
                          // } else {
                          //   CommonDialogWidgets.buildOkDialog(context, true,
                          //       "Personal information successfully updated.");
                          // }
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
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
