import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String textHint;
  final TextEditingController controller;
  const AppTextField({
    super.key,
    required this.textHint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: textHint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
