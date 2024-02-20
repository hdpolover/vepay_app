import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/tabs/home_tab.dart';
import 'package:vepay_app/screens/tabs/profile_tab.dart';
import 'package:vepay_app/screens/tabs/rate_tab.dart';
import 'package:vepay_app/screens/tabs/transaction_tab.dart';
import 'package:vepay_app/screens/tabs/withdraw_tab.dart';

class Dashboard extends StatefulWidget {
  MemberModel member;
  Dashboard({required this.member, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      HomeTab(
        member: widget.member,
      ),
      const WithdrawTab(),
      TransactionTab(),
      RateTab(),
      ProfileTab(
        member: widget.member,
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.house),
        activeColorPrimary: ColorManager.primary,
        inactiveColorPrimary: Colors.grey,
        title: "Home",
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.moneyBillTransfer),
        activeColorPrimary: ColorManager.primary,
        inactiveColorPrimary: Colors.grey,
        title: "Withdraw",
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.arrowRightArrowLeft),
        activeColorPrimary: ColorManager.primary,
        inactiveColorPrimary: Colors.grey,
        title: "Transaksi",
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.moneyBill),
        activeColorPrimary: ColorManager.primary,
        inactiveColorPrimary: Colors.grey,
        title: "Rate",
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.userLarge),
        activeColorPrimary: ColorManager.primary,
        inactiveColorPrimary: Colors.grey,
        title: "Profil",
      ),
    ];
  }

  _showModalBackDialog() {
    // show modal bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.23,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Keluar?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "Yakin untuk keluar?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  ColorManager.primary, // foreground
                            ),
                            child: const Text('Tidak'),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorManager.primary, // background
                              foregroundColor: Colors.white, // foreground
                            ),
                            child: const Text('Ya'),
                            onPressed: () async {
                              exit(0);
                              // if (Platform.isAndroid) {
                              //   Navigator.pop(context);

                              //   SystemNavigator.pop();
                              // } else if (Platform.isIOS) {
                              //   exit(0);
                              // }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showModalBackDialog();
      },
      child: Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          navBarHeight: kBottomNavigationBarHeight * 1.2,
          hideNavigationBarWhenKeyboardShows: true,
          padding: const NavBarPadding.only(top: 15),
          popActionScreens: PopActionScreensType.all,
          bottomScreenMargin: 20,
          // onWillPop: (context) async {
          //   await showDialog(
          //     context: context!,
          //     useSafeArea: true,
          //     builder: (context) => Container(
          //       height: 50.0,
          //       width: 50.0,
          //       color: Colors.white,
          //       child: ElevatedButton(
          //         child: Text("Close"),
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //       ),
          //     ),
          //   );
          //   return false;
          // },
          selectedTabScreenContext: (context) {
            var testContext = context;
          },
          hideNavigationBar: _hideNavBar,
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle:
              NavBarStyle.style6, // Choose the nav bar style with this property
        ),
      ),
    );
  }
}
