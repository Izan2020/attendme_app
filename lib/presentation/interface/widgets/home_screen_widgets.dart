import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/domain/entities/user.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopBarHome extends StatelessWidget {
  final User? credentials;
  final Function onTapSettings;
  final Function onTapProfile;
  const TopBarHome({
    super.key,
    required this.credentials,
    required this.onTapSettings,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => onTapProfile(),
                  child: ClipOval(
                    child: Image.network(
                      '${credentials?.imageUrl}',
                      height: 47,
                      width: 47,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${credentials?.jobDesk}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${credentials?.surName} ${credentials?.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
              ],
            ),
            IconButton(
              onPressed: () => onTapSettings(),
              icon: const Icon(Icons.settings),
            )
          ],
        ),
      ),
    );
  }
}

class CardAttendData {
  final String subTitle;
  final String title;
  final IconData icon;
  final Color cardColor;
  CardAttendData(this.subTitle, this.title, this.icon, this.cardColor);
}

class CardAttend extends StatefulWidget {
  final Function onTap;
  const CardAttend({super.key, required this.onTap});

  @override
  State<CardAttend> createState() => _CardAttendState();
}

class _CardAttendState extends State<CardAttend> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        CardAttendData? cardAttendData;

        switch (state) {
          case AttendedATS():
            cardAttendData = CardAttendData(
              'Youre Attended',
              state.timeAttended ?? "Unknown Time",
              Icons.check,
              AppColors.success,
            );
            break;
          case UnattendedATS():
            cardAttendData = CardAttendData(
              'Youre not Attended',
              'Attend Me!',
              Icons.warning,
              AppColors.warning,
            );
            break;
          case AbsentedATS():
            cardAttendData = CardAttendData(
              'Youre not Attending',
              'Absent',
              Icons.cancel,
              AppColors.warning,
            );
            break;
          case AbsentRequestATS():
            cardAttendData = CardAttendData(
              'Youre Absent',
              'Absent OnRequest',
              Icons.cancel,
              AppColors.warning,
            );
            break;
          case CheckedoutATS():
            cardAttendData = CardAttendData(
              'Nothing to Do',
              'Checked Out',
              Icons.done_all,
              AppColors.success,
            );
            break;
        }

        return GestureDetector(
          onTap: () => widget.onTap(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.maxFinite,
            height: 88,
            decoration: BoxDecoration(
                color: cardAttendData?.cardColor ?? Colors.grey,
                borderRadius: const BorderRadius.all(
                  Radius.circular(13),
                )),
            child: Container(
              margin: const EdgeInsets.all(14),
              child: state is LoadingATS
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        )
                      ],
                    )
                  : state is ErrorATS
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded),
                            Text(state.message ?? ""),
                            const Text('Click here to Try Again')
                          ],
                        )
                      : Row(
                          children: [
                            Icon(
                              cardAttendData?.icon ?? Icons.abc,
                              size: 56,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cardAttendData?.subTitle ?? "Sub Title",
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    cardAttendData?.title ?? "Title",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ])
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }
}
