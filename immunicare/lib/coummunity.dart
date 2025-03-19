import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/community/community_bloc.dart';
import '../bloc/community/community_event.dart';
import '../bloc/community/community_state.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedImage;

  void _addPost(BuildContext context) {
    if (_postController.text.isNotEmpty || _selectedImage != null) {
      context.read<CommunityBloc>().add(
            AddPost(
              content: _postController.text,
              image: _selectedImage,
            date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            ),
          );
      _postController.clear();
      setState(() {
        _selectedImage = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Engagement"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.blue,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Community Engagement",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _postController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Write about health tips here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImage!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text("Upload Image"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addPost(context),
                  icon: const Icon(Icons.send),
                  label: const Text("Send Post"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Previous Posts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<CommunityBloc, CommunityState>(
                builder: (context, state) {
                  if (state is CommunityLoaded) {
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['content'] ?? "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (post['image'] != null) ...[
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      post['image'],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up, size: 16, color: Colors.blue),
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: 4),
                                    Text("Like"),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.comment, size: 16, color: Colors.blue),
                                      onPressed: () {},
                                    ),
                                    Text("Reply"),
                                    const Spacer(),
                                    Text(
                                      post['date'] ?? "Unknown date",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CommunityError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}