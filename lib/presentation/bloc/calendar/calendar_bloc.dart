import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_event.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(TodaysDateCDS()) {
    on<OnUpdateDate>(
      (event, emit) async {
        if (event.dateTime.toString() == currentDateTime()) {
          emit(TodaysDateCDS());
          return;
        }
        emit(InitCDS());
        emit(CalendarDateCDS(date: event.dateTime));
      },
    );
    on<OnGetTodaysCalendar>((event, emit) async {
      emit(InitCDS());
      emit(TodaysDateCDS());
    });
  }
}
