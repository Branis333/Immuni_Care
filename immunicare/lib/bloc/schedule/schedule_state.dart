class ScheduleState {
  final List<Map<String, dynamic>> schedules;

  ScheduleState({required this.schedules});

  ScheduleState copyWith({List<Map<String, dynamic>>? schedules}) {
    return ScheduleState(schedules: schedules ?? this.schedules);
  }
}