import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/resources/color_manager.dart';

class CommonWidgets {
  buildCommonAppBar(String title) {
    return AppBar(
      title: Text(title),
      foregroundColor: Colors.black,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  buildMenuAppBar(String title) {
    return AppBar(
      title: Text(title),
      foregroundColor: Colors.black,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  buildFloatingWaButton() {
    return SizedBox(
      width: 70,
      height: 70,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: ColorManager.primary,
          child: const FaIcon(
            FontAwesomeIcons.whatsapp,
            size: 30,
          ),
        ),
      ),
    );
  }
}
