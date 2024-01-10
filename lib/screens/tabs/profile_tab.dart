import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/screens/auth/intro.dart';
import 'package:vepay_app/screens/profile/about_us.dart';
import 'package:vepay_app/screens/profile/contact_us.dart';
import 'package:vepay_app/screens/profile/edit_profile.dart';
import 'package:vepay_app/screens/profile/faq.dart';
import 'package:vepay_app/screens/profile/vcc.dart';
import 'package:vepay_app/screens/referral/referral_home.dart';
import 'package:vepay_app/services/auth_service.dart';

import '../../resources/color_manager.dart';
import '../../services/fb_service.dart';

class ProfileTab extends StatefulWidget {
  MemberModel member;
  ProfileTab({required this.member, Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  MemberModel? currentMember;

  @override
  void initState() {
    super.initState();

    setMember();
  }

  setMember() {
    setState(() {
      currentMember = widget.member;
    });
  }

  Future<void> loadProfile() async {
    try {
      currentMember = await AuthService().getMemberDetail();
      setState(() {});
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadProfile,
          color: ColorManager.primary,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            children: [
              buildHeader(),
              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  buildBody() {
    return Card(
      color: Colors.white,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: Vcc(),
                    withNavBar: false,
                  );
                },
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.creditCard,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
                title: const Text("Virtual Credit Card (VCC)"),
              ),
              ListTile(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: ReferralHome(),
                    withNavBar: false,
                  );
                },
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.ticket,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
                title: const Text("Kode Referral"),
              ),
              ListTile(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: Faq(),
                    withNavBar: false,
                  );
                },
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.question,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
                title: const Text("FAQ (Frequently Asked Questions)"),
              ),
              ListTile(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: AboutUs(),
                    withNavBar: false,
                  );
                },
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.info,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
                title: const Text("Tentang Kami"),
              ),
              ListTile(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: ContactUs(),
                    withNavBar: false,
                  );
                },
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.idCard,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
                title: const Text("Hubungi Kami"),
              ),
              ListTile(
                onTap: () {
                  if (widget.member.isGoogle == "1") {
                    FbService.signOut(context);

                    CommonMethods()
                        .saveUserLoginsDetails("", "", "", "", false, false);

                    Navigator.of(context, rootNavigator: true).pop();

                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: Intro(),
                      withNavBar: false,
                    );
                  } else {
                    FbService.signOut(context);

                    CommonMethods()
                        .saveUserLoginsDetails("", "", "", "", false, false);

                    Navigator.of(context, rootNavigator: true).pop();

                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: Intro(),
                      withNavBar: false,
                    );
                  }
                },
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: ColorManager.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: ColorManager.red,
                    ),
                  ),
                ),
                title: const Text("Keluar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(currentMember!.photo ??
                "https://vectorified.com/images/user-icon-1.png"),
            radius: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama"),
                const SizedBox(height: 5),
                Text(
                  (currentMember!.name!.isEmpty || currentMember?.name == null)
                      ? currentMember!.email!
                      : currentMember!.name!,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: EditProfile(
                  member: currentMember!,
                ),
                withNavBar: false,
              );
            },
            icon: const FaIcon(FontAwesomeIcons.penToSquare),
          ),
        ],
      ),
    );
  }
}
