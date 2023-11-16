import 'package:attendme_app/domain/entities/insert_attendance_body.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_state.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/bloc/location/location_bloc.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomSheetAbsent extends StatefulWidget {
  const BottomSheetAbsent({super.key});

  @override
  State<BottomSheetAbsent> createState() => _BottomSheetAbsentState();
}

class _BottomSheetAbsentState extends State<BottomSheetAbsent> {
  final TextEditingController messageController = TextEditingController();
  String? reason;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendingBloc, AttendingState>(
      listener: (context, state) {
        if (state is ErrorATNS) {
          context.pop();
        } else if (state is SuccessATNS) {
          final dateState = context.read<CalendarBloc>().state;
          context
              .read<AttendanceBloc>()
              .add(OnGetAttendanceStatus(dateState.date));

          context.pop();
        }
      },
      builder: (context, state) {
        return AppBottomSheet(
          onClose: () {},
          title: 'Absent',
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Reason'),
                      focusColor: Colors.grey,
                      items: const [
                        DropdownMenuItem(
                          value: 'sick',
                          child: Text('Sakit'),
                        ),
                        DropdownMenuItem(
                          value: 'permission',
                          child: Text('Izin'),
                        ),
                        DropdownMenuItem(
                          value: 'others',
                          child: Text('Lainnya'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          reason = value;
                        });
                      }),
                ),
                const SizedBox(height: 12),
                if (reason != null)
                  Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                        ),
                        onChanged: (value) => setState(() {}),
                      )),
                const SizedBox(height: 12),
                AnimatedContainer(
                    curve: Curves.decelerate,
                    height: messageController.text != "" ? 57 : 0,
                    duration: const Duration(milliseconds: 450),
                    child: PrimaryButton(
                        title: 'Send', onTap: () => absentUser())),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> absentUser() async {
    final authState = context.read<AuthBloc>().state as SuccessAS;

    final locationState = context.read<LocationBloc>().state.position;

    final AttendanceBody body = AttendanceBody(
        userId: authState.credentials!.userId!,
        companyId: authState.credentials!.companyId!,
        imageUrl: 'none',
        longitude: locationState!.longitude.toString(),
        latitude: locationState.latitude.toString(),
        status: 'on-request',
        reason: reason,
        message: messageController.text);
    return context.read<AttendingBloc>().add(OnAbsentRequestUser(body));
  }
}
