abstract class ScheduleEvent {}

class AddSchedule extends ScheduleEvent {
  final String title;
  final DateTime dateTime;

  AddSchedule({required this.title, required this.dateTime});
}