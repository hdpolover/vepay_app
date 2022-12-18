import 'package:flutter/material.dart';
import 'package:vepay_app/resources/color_manager.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.2,
              vertical: h * 0.04,
            ),
            child: Column(
              children: [
                buildHeader(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: ColorManager.primary,
          radius: 35,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo,"),
            Text(
              "Username",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        )
      ],
    );
  }
}
