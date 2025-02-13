import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CommonResponsiveUtils {
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
  static double calcSizeResponsive(BuildContext context, double landMobile, double portMobile, double landTablet, double portTablet) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return isLandscape(context) ? landMobile : portMobile;
    }
    if (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop) {
      return isLandscape(context) ? landTablet : portTablet;
    }
    return 0;
  }
}