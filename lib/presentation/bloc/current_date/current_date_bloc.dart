import 'package:attendme_app/presentation/bloc/current_date/current_date_event.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CurrentDateBloc extends Bloc<CurrentDateEvent, CurrentDateState> {
  CurrentDateBloc() : super(TodaysDateCDS(date: DateTime.now())) {
    on<OnUpdateDate>(
      (event, emit) async {
        DateTime now = DateTime.now();
        DateFormat customFormat = DateFormat('yyyy-MM-dd 00:00:00.000');
        String formattedDateTime = customFormat.format(now);

        if (event.dateTime.toString() == formattedDateTime) {
          emit(TodaysDateCDS(date: DateTime.now()));
          return;
        }
        debugPrint('Event ${event.dateTime}');
        emit(InitCDS());
        emit(CalendarDateCDS(date: event.dateTime));
      },
    );
    on<OnGetTodaysDate>((event, emit) {
      emit(TodaysDateCDS(date: DateTime.now()));
    });
  }
}
