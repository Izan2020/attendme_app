import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/domain/entities/attendance_params.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_bloc.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_event.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_state.dart';
import 'package:attendme_app/presentation/interface/screen/settings_screen.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static String routePath = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getAttendanceStatus() async {
    final userState = context.read<AuthBloc>().state as SuccessAS;
    final dateState = context.read<CurrentDateBloc>().state;

    final attendanceParams = AttendanceParams(
        date: dateState.date?.toUtc().toIso8601String(),
        userId: userState.credentials?.userId ?? 0,
        companyId: userState.credentials?.companyId ?? 0);
    return context
        .read<AttendanceBloc>()
        .add(OnGetAttendanceStatus(attendanceParams));
  }

  Future<void> getAttendanceByCalendar(DateTime date) async {
    context.read<CurrentDateBloc>().add(OnUpdateDate(date));
    final userState = context.read<AuthBloc>().state as SuccessAS;
    final newDate = context.read<CurrentDateBloc>().state.date;
    final params = AttendanceParams(
      date: newDate.toUtc().toIso8601String(),
      userId: userState.credentials?.userId ?? 0,
      companyId: userState.credentials?.companyId ?? 0,
    );

    return context.read<AttendanceBloc>().add(OnGetAttendanceStatus(params));
  }

  Future<void> validateCurrentDate() async {
    final dateState = context.read<CurrentDateBloc>().state;
    if (dateState is CalendarDateCDS) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text('This is Yesterday')));
      return;
    }
  }

  @override
  void initState() {
    getAttendanceStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, auth) {
          if (auth is SuccessAS) {
            return Column(
              children: [
                // Top Appbar
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                '${auth.credentials?.imageUrl}',
                                height: 47,
                                width: 47,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${auth.credentials?.jobDesk}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '${auth.credentials?.surName} ${auth.credentials?.lastName}',
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
                          onPressed: () {
                            context.push(SettingsScreen.routePath);
                          },
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Content Divider
                BlocBuilder<CurrentDateBloc, CurrentDateState>(
                  builder: (context, state) {
                    if (state is TodaysDateCDS || state is CalendarDateCDS) {
                      return CalendarTimeline(
                        initialDate: state.date,
                        firstDate: DateTime(state.date.year - 20 - 20, 1, 1),
                        lastDate: DateTime(state.date.year + 20, 12, 30),
                        onDateSelected: (date) {
                          debugPrint('New Date ${date.day}');
                          getAttendanceByCalendar(date);
                        },
                        leftMargin: 20,
                        monthColor: Colors.blueGrey,
                        dayColor: Colors.grey,
                        activeDayColor: Colors.white,
                        activeBackgroundDayColor: AppColors.secondaryColor,
                        selectableDayPredicate: (date) => date.day != 23,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(height: 22),
                BlocBuilder<CurrentDateBloc, CurrentDateState>(
                    builder: (context, state) {
                  return Row(
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
                      else
                        IconButton(
                            onPressed: () => context
                                .read<CurrentDateBloc>()
                                .add(OnGetTodaysDate()),
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                            ))
                    ],
                  );
                }),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          BlocBuilder<AttendanceBloc, AttendanceState>(
                            builder: (context, state) => CardAttend(
                              onTap: () async {
                                await validateCurrentDate();
                                switch (state) {
                                  case ErrorATS():
                                    getAttendanceStatus();
                                    break;
                                  case UnattendedATS():
                                    // Handle the UnattendedATS state
                                    break;

                                  case AttendedATS():
                                    // Handle the AttendedATS state
                                    // You can access timeAttended with state.timeAttended and attendanceId with state.attendanceId
                                    break;

                                  case AbsentedATS():
                                    // Handle the AbsentedATS state
                                    // You can access attendanceId with state.attendanceId
                                    break;

                                  case AbsentRequestATS():
                                    // Handle the AbsentRequestATS state
                                    break;

                                  case CheckedoutATS():
                                    // Handle the CheckedoutATS state
                                    break;

                                  default:
                                    break;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        },
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
