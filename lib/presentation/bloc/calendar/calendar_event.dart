class CalendarEvent {
  CalendarEvent();
}

class OnGetTodaysCalendar extends CalendarEvent {
  OnGetTodaysCalendar();
}

class OnUpdateDate extends CalendarEvent {
  DateTime dateTime;
  OnUpdateDate(this.dateTime);
}
