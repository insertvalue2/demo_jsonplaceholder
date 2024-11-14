// lib/views/detail_post_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/state_noti_provider/detail_post_view_model_provider.dart';

class DetailPostScreen extends ConsumerWidget {
  final int postId;

  const DetailPostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(detailPostViewModelProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: postState.when(
        data: (post) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(post.body, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
