import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class BottomSheetAttend extends StatelessWidget {
  final Function onGotoAbsent;
  final Function onGotoAttend;
  const BottomSheetAttend({
    super.key,
    required this.onGotoAbsent,
    required this.onGotoAttend,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
        onClose: () {},
        title: 'Attend',
        child: Column(
          children: [
            AttendanceButton(
              title: 'Check-In',
              onTap: () async {
                context.pop();
                Future.delayed(
                    const Duration(milliseconds: 600), () => onGotoAttend());
              },
              type: AttendanceButtonType.checkIn,
            ),
            const SizedBox(height: 12),
            AttendanceButton(
              title: 'Absent',
              onTap: () async {
                context.pop();
                Future.delayed(
                    const Duration(milliseconds: 600), () => onGotoAbsent());
              },
              type: AttendanceButtonType.absent,
            ),
            const SizedBox(height: 22),
          ],
        ));
  }
}
