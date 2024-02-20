import 'package:flutter/material.dart';

class TextStyleManager {
  static TextStyleManager? _instance;

  static TextStyleManager get instance {
    _instance ??= TextStyleManager._init();
    return _instance!;
  }

  TextStyleManager._init();

  TextStyle get heading1 => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  TextStyle get heading2 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  TextStyle get heading3 => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  TextStyle get body1 => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  TextStyle get body2 => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle get body3 => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );
}
