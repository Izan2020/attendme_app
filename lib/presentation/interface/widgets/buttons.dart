import 'package:attendme_app/common/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const PrimaryButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 57,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 153, 185, 243),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const SecondaryButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 57,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Text(title,
              style: const TextStyle(
                color: Color.fromARGB(255, 153, 185, 243),
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}

enum AttendanceButtonType { checkIn, absent }

class AttendanceButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final AttendanceButtonType type;
  const AttendanceButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 57,
        width: double.infinity,
        decoration: BoxDecoration(
            color: type == AttendanceButtonType.checkIn
                ? AppColors.success
                : AppColors.danger,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}
