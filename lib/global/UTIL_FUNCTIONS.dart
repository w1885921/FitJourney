
import 'package:fitness_project/app/data/api_success_model.dart';
import 'package:fitness_project/global/constants.dart';
import 'package:fitness_project/global/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app/data/api_error_model.dart';

void getLoader({Color color = const Color(0xFF342C2E)}) {
  Get.dialog(
    BuildCircularProgressIndicator(
      color: color,
    ),
    barrierColor: Colors.black26,
    barrierDismissible: false,
    transitionDuration: Duration(seconds: 0),
  );
}

void getback() {
  Get.back();
}

getSnackbarError(
    ApiError apiError, {
      int seconds = 2,
    }) {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
  return Get.snackbar(
    apiError.error.label,
    apiError.error.message,
    duration: Duration(seconds: seconds),
    backgroundColor: Colors.red,
    margin:
    EdgeInsets.only(top: 25.h, left: paddingGlobal, right: paddingGlobal),
    colorText: Colors.white,
  );
}

getSnackbarSuccess(ApiSuccess apiSuccess, {int seconds = 2}) {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
  return Get.snackbar(
    apiSuccess.success.title,
    apiSuccess.success.message,
    duration: Duration(seconds: seconds),
    backgroundColor: Colors.green,
    margin:
    EdgeInsets.only(top: 25.h, left: paddingGlobal, right: paddingGlobal),
    colorText: Colors.white,
  );
}

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  }
}


class HexColor extends Color {
  /// takes [hexColor] without # and return Color model
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}