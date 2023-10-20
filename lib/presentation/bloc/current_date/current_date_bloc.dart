import 'package:attendme_app/presentation/bloc/current_date/current_date_event.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentDateBloc extends Bloc<CurrentDateEvent, CurrentDateState> {
  CurrentDateBloc() : super(TodaysDateCDS(date: DateTime.now())) {
    on<OnUpdateDate>((event, emit) {
      emit(CalendarDateCDS(date: event.dateTime));
    });
    on<OnGetTodaysDate>((event, emit) {
      emit(TodaysDateCDS(date: DateTime.now()));
    });
  }
}
