import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/screens/profile/about_us.dart';
import 'package:vepay_app/screens/profile/contact_us.dart';
import 'package:vepay_app/screens/profile/edit_profile.dart';
import 'package:vepay_app/screens/profile/vcc.dart';

import '../../resources/color_manager.dart';

class ProfileTab extends StatefulWidget {
  MemberModel member;
  ProfileTab({required this.member, Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                SizedBox(
                  height: h * 0.03,
                ),
                buildBody(),
              ],
            ),
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
                onTap: () {},
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.member.photo ??
              "https://app.vepay.id/asset/images/placeholder.jpg"),
          radius: 40,
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
                widget.member.name!,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const FaIcon(FontAwesomeIcons.penToSquare),
        ),
      ],
    );
  }
}
