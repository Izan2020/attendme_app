import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/location.dart';
import 'package:attendme_app/common/snackbars.dart';
import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/entities/insert_attendance_body.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_event.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_bloc.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_event.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_state.dart';
import 'package:attendme_app/presentation/interface/fragments/bottom_sheet_attend.dart';
import 'package:attendme_app/presentation/interface/fragments/bottom_sheet_checkin.dart';
import 'package:attendme_app/presentation/interface/screen/settings_screen.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
                          CardAttend(onTap: () async {
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
                                showAttendBottomsheet(
                                    context: context,
                                    widget: BottomSheetAttend(
                                      onGotoAbsent: () {},
                                      onGotoAttend: () => showAttendBottomsheet(
                                          context: context,
                                          widget: BottomSheetCheckin(
                                              onTapCheckin: (imageLink) async {
                                            AttendanceBody body =
                                                AttendanceBody(
                                                    userId:
                                                        authState.credentials
                                                                ?.userId ??
                                                            0,
                                                    companyId: authState
                                                            .credentials
                                                            ?.companyId ??
                                                        0,
                                                    imageUrl: imageLink,
                                                    status: 'attended',
                                                    reason: null,
                                                    longitude: '12312',
                                                    latitude: '124124');
                                            context
                                                .read<AttendingBloc>()
                                                .add(OnAttendUser(body));
                                          })),
                                    ));
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
                          }),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 88,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13))),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  height: 88,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13))),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 88,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13))),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  height: 88,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13))),
                                ),
                              ),
                            ],
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

  Future<void> showAttendBottomsheet(
      {required BuildContext context, required Widget widget}) async {
    showBottomSheet(
        elevation: 120,
        enableDrag: false,
        context: context,
        builder: (context) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 300), child: widget);
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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {})
        .catchError((e) {
      debugPrint(e);
    });
  }
}
