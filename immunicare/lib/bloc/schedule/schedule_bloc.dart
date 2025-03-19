import 'package:flutter_bloc/flutter_bloc.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleState(schedules: [])) {
    on<AddSchedule>(_onAddSchedule);
  }

  void _onAddSchedule(AddSchedule event, Emitter<ScheduleState> emit) {
    final newSchedule = {
      'title': event.title,
      'dateTime': event.dateTime,
    };

    final updatedSchedules = List<Map<String, dynamic>>.from(state.schedules)..add(newSchedule);

    emit(state.copyWith(schedules: updatedSchedules));
  }
}