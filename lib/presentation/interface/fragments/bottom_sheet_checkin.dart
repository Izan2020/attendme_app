import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/common/snackbars.dart';
import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/domain/entities/upload_image_params.dart';

import 'package:attendme_app/presentation/bloc/attendance/attending/attending_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_state.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_state.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:attendme_app/presentation/interface/widgets/home_screen_widgets.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomSheetCheckin extends StatefulWidget {
  final Function(String) onTapCheckin;
  const BottomSheetCheckin({super.key, required this.onTapCheckin});

  @override
  State<BottomSheetCheckin> createState() => _BottomSheetCheckinState();
}

class _BottomSheetCheckinState extends State<BottomSheetCheckin> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendingBloc, AttendingState>(
      listener: (context, state) {
        if (state is ErrorATNS) {
          AppSnackbar.danger(context: context, text: state.message);
        } else if (state is SuccessATNS) {
          AppSnackbar.success(context: context, text: 'Attended Successfully!');
          context.pop();
        }
      },
      builder: (context, state) {
        return AppBottomSheet(
            onClose: () {},
            title: 'Check-in',
            child: BlocConsumer<ImageBloc, ImageState>(
              listener: (context, state) {
                if (state is ErrorIMS) {
                  AppSnackbar.danger(
                      context: context,
                      text: 'Unable to Upload Picture ${state.message}');
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
                          onFaceDetected: (face) {},
                          showCaptureControl: false,
                          showCameraLensControl: false,
                          autoCapture: true,
                          onCapture: (file) async {
                            await Future.delayed(
                                const Duration(milliseconds: 1200));
                            final userState =
                                context.read<AuthBloc>().state as SuccessAS;
                            final fullName =
                                '${userState.credentials?.surName} ${userState.credentials?.lastName}';
                            UploadImage upload = UploadImage(
                                fileName:
                                    '$fullName - ${simpleDateTime(value: DateTime.now(), format: 'dd, MMMM yyyy')}',
                                filePath: file!.path);
                            context
                                .read<ImageBloc>()
                                .add(OnUploadImage(upload));
                          },
                        ),
                      ),
                    if (state is SuccessIMS)
                      Image.network(state.imageLink,
                          loadingBuilder: (context, child, loadingProgress) =>
                              child),
                    const SizedBox(height: 12),
                    if (state is SuccessIMS)
                      SecondaryButton(
                          title: 'Retake Picture',
                          onTap: () =>
                              context.read<ImageBloc>().add(OnCleanState())),
                    const SizedBox(height: 12),
                    if (state is SuccessIMS)
                      PrimaryButton(
                          title: 'Check-in',
                          onTap: () => widget.onTapCheckin(state.imageLink)),
                    const SizedBox(height: 22),
                  ],
                );
              },
            ));
      },
    );
  }
}
