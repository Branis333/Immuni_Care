import 'package:flutter_bloc/flutter_bloc.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(CommunityInitial()) {
    on<AddPost>(_onAddPost);
  }

  final List<Map<String, dynamic>> _posts = [];

  void _onAddPost(AddPost event, Emitter<CommunityState> emit) {
    try {
      _posts.add({
        'content': event.content,
        'image': event.image,
      });
      emit(CommunityLoaded(posts: List.from(_posts)));
    } catch (e) {
      emit(CommunityError(message: "Failed to add post: ${e.toString()}"));
    }
  }
}