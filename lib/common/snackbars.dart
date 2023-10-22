import 'package:attendme_app/common/colors.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void danger({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: AppColors.danger,
    ));
  }

  static void success({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: AppColors.success,
    ));
  }

  static void warning({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: AppColors.warning,
    ));
  }
}
