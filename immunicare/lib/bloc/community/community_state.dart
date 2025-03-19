class CommunityState {}

class CommunityInitial extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final List<Map<String, dynamic>> posts;

  CommunityLoaded({required this.posts});
}

class CommunityError extends CommunityState {
  final String message;

  CommunityError({required this.message});
}