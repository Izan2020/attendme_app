class CurrentDateEvent {
  CurrentDateEvent();
}

class OnGetTodaysDate extends CurrentDateEvent {
  OnGetTodaysDate();
}

class OnUpdateDate extends CurrentDateEvent {
  final DateTime dateTime;
  OnUpdateDate(this.dateTime);
}
