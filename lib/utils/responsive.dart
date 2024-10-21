import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Responsive {
  static double getWidth(double width) {
    return width / 375; // Adjust based on your design's base width
  }

  static double getHeight(double height) {
    return height / 812; // Adjust based on your design's base height
  }

  static double getFontSize(double size) {
    return size * (Get.width / 375); // Responsive font size based on screen width
  }
}
