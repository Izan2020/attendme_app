import 'dart:io';

import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/snackbars.dart';
import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/domain/entities/insert_attendance_body.dart';
import 'package:attendme_app/domain/entities/upload_image_params.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';

import 'package:attendme_app/presentation/bloc/attendance/attending/attending_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_state.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_state.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/bloc/location/location_bloc.dart';
import 'package:attendme_app/presentation/bloc/location/location_event.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomSheetCheckin extends StatefulWidget {
  const BottomSheetCheckin({super.key});

  @override
  State<BottomSheetCheckin> createState() => _BottomSheetCheckinState();
}

class _BottomSheetCheckinState extends State<BottomSheetCheckin> {
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
      builder: (context, attendingState) {
        return AppBottomSheet(
            onClose: () {},
            title: 'Check-in',
            child: BlocConsumer<ImageBloc, ImageState>(
              listener: (context, state) {
                if (state is ErrorIMS) {
                  AppSnackbar.danger(
                      context: context,
                      text: 'Unable to Upload Picture ${state.message}');
                  context.pop();
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    if (state is LoadingIMS)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 22),
                          Text(
                            'Uploading Image...',
                            style: TextStyle(color: AppColors.primaryColor),
                          )
                        ],
                      ),
                    if (state is InitIMS)
                      Container(
                        width: double.infinity,
                        height: 530,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: SmartFaceCamera(
                          messageStyle: const TextStyle(color: Colors.white),
                          message: 'Say Cheese !',
                          defaultCameraLens: CameraLens.front,
                          defaultFlashMode: CameraFlashMode.off,
                          showCaptureControl: false,
                          showCameraLensControl: false,
                          autoCapture: true,
                          onCapture: (file) {
                            context
                                .read<LocationBloc>()
                                .add(OnGetCurrentLocation());
                            uploadImage(file);
                          },
                        ),
                      ),
                    if (state is SuccessIMS)
                      Image.network(state.imageLink,
                          loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }),
                    const SizedBox(height: 12),
                    if (state is SuccessIMS && attendingState != LoadingATNS())
                      Column(
                        children: [
                          SecondaryButton(
                              title: 'Retake Picture',
                              onTap: () => context
                                  .read<ImageBloc>()
                                  .add(OnCleanState())),
                          const SizedBox(height: 12),
                          PrimaryButton(
                              title: 'Check-in',
                              onTap: () => uploadAttendance()),
                          const SizedBox(height: 22),
                        ],
                      ),
                    if (attendingState is LoadingATNS)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 22),
                          Text(
                            'Uploading Attendance',
                            style: TextStyle(color: AppColors.primaryColor),
                          )
                        ],
                      ),
                  ],
                );
              },
            ));
      },
    );
  }

  Future<void> uploadImage(File? file) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final userState = context.read<AuthBloc>().state as SuccessAS;
    final fullName =
        '${userState.credentials?.surName} ${userState.credentials?.lastName}';
    UploadImage upload = UploadImage(
        fileName:
            '$fullName - ${simpleDateTime(value: DateTime.now(), format: 'dd, MMMM yyyy')}',
        filePath: file!.path);
    context.read<ImageBloc>().add(OnUploadImage(upload));
  }

  Future<void> uploadAttendance() async {
    final authState = context.read<AuthBloc>().state as SuccessAS;
    final imageBloc = context.read<ImageBloc>().state as SuccessIMS;
    final locationState = context.read<LocationBloc>().state.position;
    final imageUrl = imageBloc.imageLink;
    final AttendanceBody body = AttendanceBody(
        userId: authState.credentials?.userId ?? 0,
        companyId: authState.credentials?.companyId ?? 0,
        imageUrl: imageUrl,
        longitude: locationState!.longitude.toString(),
        latitude: locationState.latitude.toString(),
        status: 'attended',
        reason: 'none');
    context.read<AttendingBloc>().add(OnAttendUser(body));
  }
}
