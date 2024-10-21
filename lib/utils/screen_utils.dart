// lib/utils/screen_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }

  static double getHeight(double height) {
    return height.h;
  }

  static double getWidth(double width) {
    return width.w;
  }

  static double getFontSize(double fontSize) {
    return fontSize.sp;
  }

  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  static EdgeInsets getPadding(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(left.w, top.h, right.w, bottom.h);
  }

  static EdgeInsets getAllPadding(double padding) {
    return EdgeInsets.all(padding.w);
  }

  static double getScreenWidth() {
    return 1.sw;
  }

  static double getScreenHeight() {
    return 1.sh;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width <= 1200;
  }
}
