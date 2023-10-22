import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/domain/entities/user.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
              'Youre Attended.',
              simpleDateTime(value: state.timeAttended!, format: 'hh:mm a'),
              Icons.check,
              AppColors.success,
            );
            break;
          case UnattendedATS():
            cardAttendData = CardAttendData(
              'Youre not Attended.',
              'Not Attended',
              Icons.warning,
              AppColors.warning,
            );
            break;
          case AbsentedATS():
            cardAttendData = CardAttendData(
              'Youre not Attending.',
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
          case WeekendATS():
            cardAttendData = CardAttendData(
              'Its Weekend Day',
              'Nothing to do!',
              Icons.weekend,
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
          case FutureDateATS():
            cardAttendData = CardAttendData(
              'Attend this in the Future',
              'Attend this Soon',
              Icons.work_history,
              AppColors.warning,
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
                ),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.1,
                      blurRadius: 10,
                      color: cardAttendData?.cardColor ?? Colors.black)
                ]),
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

class BottomSheetAttend extends StatefulWidget {
  const BottomSheetAttend({super.key});

  @override
  State<BottomSheetAttend> createState() => _BottomSheetAttendState();
}

class _BottomSheetAttendState extends State<BottomSheetAttend> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Attend',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close_sharp),
                )
              ]),
              const Divider(),
              const SizedBox(height: 12),
              AttendanceButton(
                title: 'Check-In',
                onTap: () {},
                type: AttendanceButtonType.checkIn,
              ),
              const SizedBox(height: 12),
              AttendanceButton(
                title: 'Absent',
                onTap: () {},
                type: AttendanceButtonType.absent,
              ),
              const SizedBox(height: 22),
            ]),
          )
        ],
      ),
    );
  }
}
