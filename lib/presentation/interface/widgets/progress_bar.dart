import 'package:attendme_app/common/colors.dart';
import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  final double value;

  const AppProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          height: 41,
          child: LinearProgressIndicator(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            value: value / 100.0,
            color: AppColors.secondaryColor,
          ),
        ),
        Positioned(left: 20, top: 22, child: Text(value.toString())),
      ],
    );
  }
}
