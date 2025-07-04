import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:vepay_app/common/common_shimmer.dart';
import 'package:vepay_app/common/responsive_utils.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/models/profile_request_model.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/home/product_item_widget.dart';
import 'package:vepay_app/screens/home/promo_item_widget.dart';
import 'package:vepay_app/screens/home/promo_see_all.dart';
import 'package:vepay_app/services/promo_service.dart';

import '../../common/common_dialog.dart';
import '../../models/rate_model.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../services/rate_service.dart';
import '../../services/transaction_service.dart';
import '../transaction/transaction_item_widget.dart';

class HomeTab extends StatefulWidget {
  MemberModel member;
  HomeTab({required this.member, super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<RateModel> rates = [];
  List<PromoModel>? promos;
  List<TransactionModel>? transactionList;

  MemberModel? member;

  @override
  void initState() {
    setMember();
    _getAllData();

    super.initState();
  }

  setMember() {
    setState(() {
      member = widget.member;
    });
  }

  Future<void> _getAllData() async {
    try {
      member = await AuthService().getMemberDetail();

      dev.log(member!.toJson().toString(), name: 'TEST');

      // * handle user ketika nomor hp null atau kosong
      if (member!.phone!.isEmpty ||
          member?.phone == null ||
          member!.phone!.length < 10 ||
          member!.name!.isEmpty ||
          member?.name == null) {
        TextEditingController? nameController = TextEditingController();
        TextEditingController? phoneController = TextEditingController();

        _showMyDialog(
          userId: member?.userId ?? '',
          phoneController: phoneController,
          nameController: nameController,
          isShowName: (member!.name!.isEmpty || member?.name == null),
          isShowPhone: (member!.phone!.isEmpty ||
              member?.phone == null ||
              member!.phone!.length < 10),
          nameField: member?.name,
          phoneField: member?.phone,
        );
        setState(() {});
        return;
      }
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());
    }

    getRates();
    getPromos();
    getTrans();
  }

  Future<void> getPromos() async {
    await PromoService().getPromos().then((value) async {
      promos = value;
    });

    // remove items with status 0
    promos!.removeWhere((element) => element.status == "0");

    setState(() {});
  }

  Future<void> getRates() async {
    try {
      List<RateModel> tempRates = await RateService().getRates("top_up");

      if (tempRates.length <= 9) {
        // tempRates
        //     .sublist(0, 3);
            // .removeWhere((element) => element.name!.toLowerCase() == "more");

        rates = tempRates;
      } else {
        rates = tempRates.sublist(0, 8);
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTrans() async {
    try {
      transactionList = await TransactionService().getTransactionHistory();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              rates = [];
              promos = [];
              transactionList = [];
            });

            _getAllData();
          },
          color: ColorManager.primary,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.055,
              vertical: h * 0.04,
            ),
            child: ListView(
              children: [
                buildHeader(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Top up/Beli",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                buildProductSection(),
                transactionList != null && transactionList!.isEmpty
                    ? Container()
                    : buildTransSection(),
                const SizedBox(height: 10),
                promos == null ? Container() : buildPromotionSection(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildTransSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Transaksi Terbaru",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        transactionList == null
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final height = MediaQuery.of(context).size.height *
                      (ResponsiveBreakpoints.of(context).isTablet ||
                              ResponsiveBreakpoints.of(context).isDesktop
                          ? (ResponsiveBreakpoints.of(context).orientation ==
                                  Orientation.landscape
                              ? 0.4
                              : 0.3)
                          : 0.2);

                  return Container(
                    height: height,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      itemCount: 2,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CommonShimmer().buildPromoItemShimmer(context);
                      },
                    ),
                  );
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: transactionList!.length > 1 ? 2 : 1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return TransactionItemWidget(
                      transaction: transactionList![index]);
                },
              ),
      ],
    );
  }

  buildProductSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final minItemWidth = screenWidth * 0.4;

    return ResponsiveGridList(
      minItemsPerRow: 4,
      horizontalGridSpacing: 4,
      verticalGridSpacing: 4,
      listViewBuilderOptions: ListViewBuilderOptions(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // This allows the grid to size based on content
      ),
      minItemWidth: minItemWidth,
      children: rates.isEmpty
          ? List.generate(
              8,
              (index) => CommonShimmer().buildProductItemShimmer(context),
              growable: false,
            )
          : List.generate(
              rates.length,
              (index) => buildProductItemWidget(rates[index]),
              growable: false,
            ),
    );
  }

  buildProductItemWidget(RateModel rateModel) {
    return ProductItemWidget(
      rateModel: rateModel,
    );
  }

  buildPromotionSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Promo dan Berita",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PromoSeeAll(
                      promos: promos!,
                    ),
                    withNavBar: false,
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: ColorManager.primary,
                  ),
                ))
          ],
        ),
        LayoutBuilder(builder: (context, constraints) {
          final height = MediaQuery.of(context).size.height *
              (ResponsiveBreakpoints.of(context).isTablet ||
                  ResponsiveBreakpoints.of(context).isDesktop ?
              (ResponsiveBreakpoints.of(context).orientation == Orientation.landscape ? 0.5 : 0.24) : 0.21);

          return Container(
            height: height,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemCount: promos?.length ?? 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return promos == null || promos!.isEmpty
                    ? CommonShimmer().buildPromoItemShimmer(context)
                    : PromoItemWidget(
                        promo: promos![index],
                        source: "home",
                      );
              },
            ),
          );
        })
        // promos == null || promos!.isEmpty
        //     ? SizedBox(
        //   // height: MediaQuery.of(context).size.height * 0.16,
        //   height: MediaQuery.of(context).size.height * (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop ? 0.3 : 0.16),
        //         child: ListView.builder(
        //           padding: const EdgeInsets.symmetric(vertical: 10),
        //           shrinkWrap: true,
        //           itemCount: 2,
        //           scrollDirection: Axis.horizontal,
        //           itemBuilder: (context, index) {
        //             return CommonShimmer().buildPromoItemShimmer(context);
        //           },
        //         ),
        //       )
        //     : SizedBox(
        //   // height: MediaQuery.of(context).size.height * 0.21,
        //   height: MediaQuery.of(context).size.height * (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop ? (ResponsiveBreakpoints.of(context).orientation == Orientation.landscape ? 0.5 : 0.24) : 0.21),
        //         child: ListView.builder(
        //           padding: const EdgeInsets.symmetric(vertical: 10),
        //           shrinkWrap: true,
        //           itemCount: promos!.length,
        //           scrollDirection: Axis.horizontal,
        //           itemBuilder: (context, index) {
        //             return PromoItemWidget(
        //               promo: promos![index],
        //               source: "home",
        //             );
        //           },
        //         ),
        //       ),
      ],
    );
  }

  buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(member!.photo ??
              "https://vectorified.com/images/user-icon-1.png"),
          radius: 30,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo,"),
              const SizedBox(height: 3),
              Text(
                (member!.name!.isEmpty || member?.name == null)
                    ? "${member!.email}!"
                    : "${member!.name}!",
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            // Image(
            //   width: MediaQuery.of(context).size.width * 0.08,
            //   height: MediaQuery.of(context).size.height * 0.04,
            //   image: const AssetImage('assets/vepay_logo.png'),
            // ),
            // Image(
            //   width: MediaQuery.of(context).size.width * 0.18,
            //   height: MediaQuery.of(context).size.height * 0.05,
            //   image: const AssetImage('assets/vepay_text.png'),
            // ),
            LayoutBuilder(builder: (context, constrains) {
              final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
              final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
              double logoHeight;

              if (isTablet) {
                // Different sizing for tablet orientations
                logoHeight = isLandscape
                    ? MediaQuery.of(context).size.height * 0.05  // Larger in landscape to compensate for smaller height
                    : MediaQuery.of(context).size.height * 0.03; // Standard size in portrait
              } else {
                // Phone sizing
                logoHeight = isLandscape
                    ? MediaQuery.of(context).size.height * 0.09  // Larger in landscape to compensate for smaller height
                    : MediaQuery.of(context).size.height * 0.035; // Standard size in portrait
              }

              final minHeight = min(16.0, logoHeight * 0.8);

              return Container(
                constraints: BoxConstraints(
                  maxHeight: logoHeight,
                  minHeight: minHeight, // Minimum height for visibility
                ),
                child: Image.asset(
                  'assets/vepay_logo_2.png',
                  fit: BoxFit.contain,
                ),
              );
            }),
            // Image(
            //   // width: MediaQuery.of(context).size.width * 0.18,
            //   height: MediaQuery.of(context).size.height * 0.05,
            //   image: const AssetImage('assets/vepay_logo_2.png'),
            // ),
          ],
        ),
      ],
    );
  }

  Future<void> _showMyDialog({
    required TextEditingController phoneController,
    required TextEditingController nameController,
    required bool isShowName,
    required bool isShowPhone,
    required String userId,
    String? nameField,
    String? phoneField,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();

        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Silahkan Lengkapi Data Anda'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: isShowPhone,
                    child: TextFormField(
                      controller: phoneController,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Harap masukan nomor telepon'),
                        MinLengthValidator(9,
                            errorText:
                                "Panjang nomor telepon minimal 10 karakter"),
                        MaxLengthValidator(15,
                            errorText:
                                "Panjang nomor telepon maksimal 15 karakter"),
                      ]),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^ ?\d*')),
                        FilteringTextInputFormatter.deny(RegExp(r'^ ?\D*')),
                        FilteringTextInputFormatter.deny(' '),
                        FilteringTextInputFormatter.digitsOnly
                      ],
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
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: isShowName,
                    child: TextFormField(
                      controller: nameController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Harap masukan nama'),
                      ]),
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
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Do something with the entered data
                    String phone = phoneController.text;
                    String name = nameController.text;

                    var data = ProfileRequestModel(
                      userId: userId,
                      name: name.isEmpty ? nameField : name,
                      phone: phone.isEmpty ? phoneField : phone,
                    );

                    try {
                      CommonDialog.showLoading(context);

                      bool res = await AuthService().updateDetailProfile(data);

                      Navigator.of(context).pop();

                      if (res) {
                        CommonDialog.buildOkUpdateDialog(
                            context, true, "Berhasil memperbarui profil.");
                      } else {
                        CommonDialog.buildOkDialog(
                            context, false, "Terjadi kesalahan. Coba lagi.");
                      }
                    } catch (e) {
                      CommonDialog.buildOkDialog(context, false, e.toString());
                    }

                    phoneController.dispose();
                    nameController.dispose();

                    _getAllData();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
