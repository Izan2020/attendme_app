import 'package:attendme_app/common/colors.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required Function onTapNegative,
    required Function onTapPositive,
  }) {
    return showDialog(
        context: context,
        builder: (build) {
          return AlertDialog.adaptive(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => onTapNegative(),
                child: Text(
                  'No',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
              TextButton(
                onPressed: () => onTapPositive(),
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }

  static Future<void> showLoaderDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.white,
                )));
      },
    );
  }
}
