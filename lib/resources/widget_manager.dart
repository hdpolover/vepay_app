import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/resources/text_style_manager.dart';

class WidgetManager {
  static final WidgetManager _instance = WidgetManager._internal();
  factory WidgetManager() => _instance;
  WidgetManager._internal();

  buildTextItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Text(
          title,
          style: TextStyleManager.instance.body2,
        )),
        Expanded(
            child: Text(
          value,
          style: TextStyleManager.instance.body2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }

  buildTextItem2(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(
          title,
          style: TextStyleManager.instance.body2,
        )),
        Text(
          value,
          style: TextStyleManager.instance.body2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  buildTextItemToCopy(
      String title, String value, bool isToCopy, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(
          title,
          style: TextStyleManager.instance.body2,
        )),
        Expanded(
            child: Text(
          value,
          style: TextStyleManager.instance.body2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        )),
        isToCopy
            ? InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Berhasil menyalin text ke clipboard")));
                  });
                },
                child: Icon(
                  Icons.copy,
                  size: 17,
                  color: ColorManager.primary,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
