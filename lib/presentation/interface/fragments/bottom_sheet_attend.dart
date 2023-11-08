import 'package:attendme_app/presentation/interface/fragments/bottom_sheet_absent.dart';
import 'package:attendme_app/presentation/interface/fragments/bottom_sheet_checkin.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomSheetAttend extends StatelessWidget {
  const BottomSheetAttend({
    super.key,
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
                moveBottomSheet(context, widget: const BottomSheetCheckin());
              },
              type: AttendanceButtonType.checkIn,
            ),
            const SizedBox(height: 12),
            AttendanceButton(
              title: 'Absent',
              onTap: () async {
                moveBottomSheet(context, widget: const BottomSheetAbsent());
              },
              type: AttendanceButtonType.absent,
            ),
            const SizedBox(height: 22),
          ],
        ));
  }

  Future<void> moveBottomSheet(BuildContext context,
      {required Widget widget}) async {
    context.pop();
    Future.microtask(() => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (builder) => widget,
        ));
  }
}
