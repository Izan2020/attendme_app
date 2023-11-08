import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/haptic_feedbacks.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void danger({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 400),
      content: Text(text),
      backgroundColor: AppColors.danger,
    ));
    AppHaptics.danger();
  }

  static void success({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 400),
      content: Text(text),
      backgroundColor: AppColors.success,
    ));
    AppHaptics.danger();
  }

  static void warning({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 400),
      content: Text(text),
      backgroundColor: AppColors.warning,
    ));
    AppHaptics.danger();
  }
}
