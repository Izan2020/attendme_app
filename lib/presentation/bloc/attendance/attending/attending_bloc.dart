import 'package:attendme_app/domain/usecases/check_out_user.dart';
import 'package:attendme_app/domain/usecases/insert_attendance.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendingBloc extends Bloc<AttendingEvent, AttendingState> {
  final AttendUser attendUser;
  final CheckoutUser checkoutUser;
  AttendingBloc({
    required this.attendUser,
    required this.checkoutUser,
  }) : super(OnInitATNS()) {
    on<OnAttendUser>((event, emit) async {
      emit(OnLoadingATNS());
      final result = await attendUser.execute(event.body);
      result.fold(
        (failure) {
          emit(OnErrorATNS(failure.message));
        },
        (success) {
          emit(OnSuccessATNS());
          emit(OnInitATNS());
        },
      );
    });
    on<OnAbsentRequestUser>((event, emit) async {
      emit(OnLoadingATNS());
      final result = await attendUser.execute(event.body);
      result.fold(
        (failure) {
          emit(OnErrorATNS(failure.message));
        },
        (success) {
          emit(OnSuccessATNS());
          emit(OnInitATNS());
        },
      );
    });
    on<OnCheckoutUser>((event, emit) async {
      emit(OnLoadingATNS());
      final result = await checkoutUser.execute(event.userId);
      result.fold(
        (failure) => emit(OnErrorATNS(failure.message)),
        (success) {
          emit(OnSuccessATNS());
          emit(OnInitATNS());
        },
      );
    });
  }
}
