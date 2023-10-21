class CurrentDateEvent {
  CurrentDateEvent();
}

class OnGetTodaysDate extends CurrentDateEvent {
  OnGetTodaysDate();
}

class OnUpdateDate extends CurrentDateEvent {
  DateTime dateTime;
  OnUpdateDate(this.dateTime);
}
