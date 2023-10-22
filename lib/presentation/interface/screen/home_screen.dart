import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/snackbars.dart';
import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_bloc.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_event.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_state.dart';
import 'package:attendme_app/presentation/interface/screen/settings_screen.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
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
  @override
  void initState() {
    debugPrint('Baru Masuk Home');
    getAttendanceStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is SuccessAS) {
            final auth = authState;
            return Column(
              children: [
                // Top Appbar
                TopBarHome(
                  credentials: auth.credentials,
                  onTapSettings: () => context.push(SettingsScreen.routePath),
                  onTapProfile: () {},
                ),
                const SizedBox(height: 8),
                // Content Divider
                BlocBuilder<CurrentDateBloc, CurrentDateState>(
                  builder: (context, state) {
                    return CalendarTimeline(
                      initialDate: state.date,
                      firstDate: DateTime(state.date.year - 20 - 20, 1, 1),
                      lastDate: DateTime(state.date.year + 20, 12, 30),
                      onDateSelected: (date) => getAttendanceByCalendar(date),
                      leftMargin: 20,
                      monthColor: Colors.blueGrey,
                      dayColor: Colors.grey,
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: AppColors.secondaryColor,
                    );
                  },
                ),
                const SizedBox(height: 22),
                BlocBuilder<CurrentDateBloc, CurrentDateState>(
                    builder: (context, state) {
                  return Row(
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
                            onPressed: () {
                              context
                                  .read<CurrentDateBloc>()
                                  .add(OnGetTodaysDate());
                              Future.microtask(() => getAttendanceStatus());
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                            )),
                      Container(
                        margin: const EdgeInsets.all(11),
                        child: Text(
                          simpleDateTime(
                              value: state.date, format: 'dd, MMMM yyyy'),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: AppColors.primaryColor),
                        ),
                      )
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
                          CardAttend(
                            onTap: () async {
                              final currentDate =
                                  context.read<CurrentDateBloc>().state;
                              final attendanceState =
                                  context.read<AttendanceBloc>().state;

                              if (authState is LoadingATS) return;
                              if (currentDate is CalendarDateCDS) return;

                              switch (attendanceState) {
                                case ErrorATS():
                                  getAttendanceStatus();
                                  break;
                                case UnattendedATS():
                                  showAttendBottomsheet(context);
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
                                  AppSnackbar.danger(
                                      context: context,
                                      text: "You're checked-out");
                                  break;
                                case WeekendATS():
                                  AppSnackbar.warning(
                                      context: context,
                                      text: "It's Weekend Day!");
                                  break;
                                case FutureDateATS():
                                  AppSnackbar.warning(
                                      context: context, text: "Attend Soon");
                                  break;
                                default:
                                  break;
                              }
                            },
                          ),
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

  Future<void> showAttendBottomsheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAttend();
        });
    return;
  }

  Future<void> getAttendanceStatus() async {
    final userState = context.read<AuthBloc>().state as SuccessAS;
    final dateState = context.read<CurrentDateBloc>().state;

    final attendanceParams = CheckAttendanceParams(
        date: dateState.date,
        userId: userState.credentials?.userId ?? 0,
        companyId: userState.credentials?.companyId ?? 0);
    return context
        .read<AttendanceBloc>()
        .add(OnGetAttendanceStatus(attendanceParams));
  }

  Future<void> getAttendanceByCalendar(DateTime date) async {
    context.read<CurrentDateBloc>().add(OnUpdateDate(date));
    final userState = context.read<AuthBloc>().state as SuccessAS;
    final params = CheckAttendanceParams(
      date: date,
      userId: userState.credentials?.userId ?? 0,
      companyId: userState.credentials?.companyId ?? 0,
    );

    return context.read<AttendanceBloc>().add(OnGetAttendanceStatus(params));
  }
}
