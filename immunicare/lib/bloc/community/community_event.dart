import 'dart:io';

abstract class CommunityEvent {}

class AddPost extends CommunityEvent {
  final String content;
  final File? image;

  AddPost({required this.content, this.image, required String date});
}