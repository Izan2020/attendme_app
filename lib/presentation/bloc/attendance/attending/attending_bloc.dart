import 'package:attendme_app/domain/usecases/check_out_user.dart';
import 'package:attendme_app/domain/usecases/insert_attendance.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendingBloc extends Bloc<AttendingEvent, AttendingState> {
  final AttendUser attendUser;
  final CheckoutUser checkoutUser;
  AttendingBloc({
    required this.attendUser,
    required this.checkoutUser,
  }) : super(InitATNS()) {
    on<OnAttendUser>((event, emit) async {
      emit(LoadingATNS());
      final result = await attendUser.execute(event.body);
      result.fold(
        (failure) {
          emit(ErrorATNS(failure.message));
        },
        (success) {
          emit(SuccessATNS('Attended Successfully!'));
          emit(InitATNS());
        },
      );
    });
    on<OnAbsentRequestUser>((event, emit) async {
      emit(LoadingATNS());
      final result = await attendUser.execute(event.body);
      result.fold(
        (failure) {
          emit(ErrorATNS(failure.message));
        },
        (success) {
          emit(SuccessATNS('Absent Request Sent!'));
          emit(InitATNS());
        },
      );
    });
    on<OnCheckoutUser>((event, emit) async {
      emit(LoadingATNS());
      debugPrint('Checking out');
      final result = await checkoutUser.execute(event.userId);
      result.fold(
        (failure) => emit(ErrorATNS(failure.message)),
        (success) {
          debugPrint('result $success');
          emit(SuccessATNS('Checked-out Successfully!'));
          emit(InitATNS());
        },
      );
    });
  }
}
