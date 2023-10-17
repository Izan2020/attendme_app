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
  const SecondaryButton({super.key, required this.title, required this.onTap});

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
