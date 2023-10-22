import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_event.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentDateBloc extends Bloc<CurrentDateEvent, CurrentDateState> {
  CurrentDateBloc() : super(TodaysDateCDS()) {
    on<OnUpdateDate>(
      (event, emit) async {
        if (event.dateTime.toString() == currentDateTime()) {
          emit(TodaysDateCDS());
          return;
        }
        debugPrint('Event ${event.dateTime}');
        emit(InitCDS());
        emit(CalendarDateCDS(date: event.dateTime));
      },
    );
    on<OnGetTodaysDate>((event, emit) {
      emit(TodaysDateCDS());
    });
  }
}
