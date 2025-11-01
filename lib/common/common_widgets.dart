import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/resources/color_manager.dart';

import 'common_method.dart';

class CommonWidgets {
  buildCommonAppBar(String title) {
    return AppBar(
      title: Text(title),
      foregroundColor: Colors.black,
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
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
      width: 50,
      height: 50,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            CommonMethods().launchWhatsAppUri(
                "Halo, Admin. Saya ingin bertanya tentang Vepay.id");
          },
          backgroundColor: ColorManager.primary,
          child: const FaIcon(
            FontAwesomeIcons.whatsapp,
            size: 30,
          ),
        ),
      ),
    );
  }

  buildStatusChip(int status) {
    Chip? value;
    Color? bgColor;
    Color? textColor;

    switch (status) {
      case 1:
        bgColor = Colors.orange;
        textColor = Colors.white;
        break;
      case 2:
        bgColor = Colors.green;
        textColor = Colors.white;
        break;
      case 3:
        bgColor = Colors.red;
        textColor = Colors.white;
        break;
      case 4:
        bgColor = Colors.grey;
        textColor = Colors.black;
        break;
    }

    value = Chip(
      side: const BorderSide(color: Colors.white, width: 1),
      backgroundColor: bgColor,
      label: Text(
        CommonMethods().getStatusLabel(
          status,
        ),
        style: TextStyle(color: textColor!),
      ),
    );

    return value;
  }

  buildTextItem(BuildContext context, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Text(title)),
        Expanded(
            child: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
}
