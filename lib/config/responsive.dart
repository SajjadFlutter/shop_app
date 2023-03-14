import 'package:flutter/material.dart';

class Responsive {
  // isMobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  // isTablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1100;

  // isDesctop
  static bool isDesctop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}
