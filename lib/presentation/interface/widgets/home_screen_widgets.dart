import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/timestamp.dart';

import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_state.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class TopBarHome extends StatelessWidget {
  final Function onTapSettings;
  final Function onTapProfile;
  const TopBarHome({
    super.key,
    required this.onTapSettings,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is SuccessAS) {
          final credentials = state.credentials;
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
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('');
                            },
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
        } else {
          return Container();
        }
      },
    );
  }
}

class HomeCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function onTapResetCalendar;
  final bool selectable;
  const HomeCalendar({
    super.key,
    required this.onDateSelected,
    required this.onTapResetCalendar,
    required this.selectable,
  });
  @override
  State<HomeCalendar> createState() => HomeCalendarState();
}

class HomeCalendarState extends State<HomeCalendar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Column(
          children: [
            CalendarTimeline(
              showYears: false,
              selectableDayPredicate: (day) {
                if (!widget.selectable) {
                  return day == state.date;
                } else {
                  return true;
                }
              },
              initialDate: state.date,
              firstDate: DateTime(state.date.year - 20 - 20, 1, 1),
              lastDate: DateTime(state.date.year + 20, 12, 30),
              onDateSelected: (date) => widget.onDateSelected(date),
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Colors.grey,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: AppColors.secondaryColor,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state is TodaysDateCDS)
                  Container(
                    margin: const EdgeInsets.all(11),
                    child: Text(
                      'Today',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                  )
                else if (state is CalendarDateCDS)
                  IconButton(
                      onPressed: () => widget.onTapResetCalendar(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: widget.selectable
                            ? AppColors.secondaryColor
                            : Colors.grey,
                      )),
                Container(
                  margin: const EdgeInsets.all(11),
                  child: Text(
                    simpleDateTime(value: state.date, format: 'dd, MMMM yyyy'),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: AppColors.primaryColor),
                  ),
                )
              ],
            )
          ],
        );
      },
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
              simpleDateTime(
                  value: state.timeAttended!.toLocal(), format: 'hh:mm a'),
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
              'On Request',
              Icons.person_pin_rounded,
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
                        SpinKitFoldingCube(
                          color: Colors.white,
                          size: 20.0,
                        )
                      ],
                    )
                  : state is ErrorATS
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message ?? "",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(
                              cardAttendData?.icon,
                              size: 56,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cardAttendData?.subTitle ?? "",
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    cardAttendData?.title ?? "",
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

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Function onClose;
  const AppBottomSheet(
      {super.key,
      required this.title,
      required this.child,
      required this.onClose});

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
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    onClose();
                    context.pop();
                  },
                  icon: const Icon(Icons.close_sharp),
                )
              ]),
              const Divider(),
              const SizedBox(height: 12),
              child
            ]),
          )
        ],
      ),
    );
  }
}
