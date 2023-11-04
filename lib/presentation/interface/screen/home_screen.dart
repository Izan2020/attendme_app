import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/location.dart';
import 'package:attendme_app/common/snackbars.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_event.dart';

import 'package:attendme_app/presentation/bloc/calendar/calendar_state.dart';
import 'package:attendme_app/presentation/interface/fragments/bottom_sheet_attend.dart';
import 'package:attendme_app/presentation/interface/screen/settings_screen.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:face_camera/face_camera.dart';
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
    FaceCamera.initialize();
    getTodaysAttendance();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // Top Appbar
        TopBarHome(
          onTapSettings: () => context.push(SettingsScreen.routePath),
          onTapProfile: () {},
        ),
        const SizedBox(height: 8),
        // Content Divider
        HomeCalendar(
          selectable: context.select<AttendanceBloc, AttendanceState>(
                  (value) => value.state) !=
              LoadingATS(),
          onDateSelected: (date) => getAttendanceByCalendar(date),
          onTapResetCalendar: () {
            context.read<CalendarBloc>().add(OnGetTodaysCalendar());
            Future.microtask(() => getTodaysAttendance());
          },
        ),

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
                      final currentDate = context.read<CalendarBloc>().state;
                      final attendanceState =
                          context.read<AttendanceBloc>().state;

                      if (attendanceState is ErrorATS) {
                        return getTodaysAttendance();
                      }
                      if (attendanceState is LoadingATS) return;
                      if (currentDate is CalendarDateCDS) {
                        return AppSnackbar.warning(
                            context: context, text: "It's not Today");
                      }

                      switch (attendanceState) {
                        case ErrorATS():
                          break;
                        case UnattendedATS():
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => const BottomSheetAttend());
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
                              context: context, text: "You're checked-out");
                          break;
                        case WeekendATS():
                          AppSnackbar.warning(
                              context: context, text: "It's Weekend Day!");
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
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
    ));
  }

  Future<void> getTodaysAttendance() async {
    final dateState = context.read<CalendarBloc>().state.date;
    return Future.microtask(() =>
        context.read<AttendanceBloc>().add(OnGetAttendanceStatus(dateState)));
  }

  Future<void> getAttendanceByCalendar(DateTime date) async {
    context.read<CalendarBloc>().add(OnUpdateDate(date));

    Future.microtask(
        () => context.read<AttendanceBloc>().add(OnGetAttendanceStatus(date)));
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    final newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
