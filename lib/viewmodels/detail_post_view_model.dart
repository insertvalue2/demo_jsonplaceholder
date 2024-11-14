// lib/viewmodels/detail_post_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class DetailPostViewModel extends StateNotifier<AsyncValue<Post>> {
  final PostService _postService;
  final int postId;

  DetailPostViewModel(this._postService, this.postId)
      : super(const AsyncValue.loading()) {
    fetchPost();
  }

  Future<void> fetchPost() async {
    try {
      final post = await _postService.fetchPostById(postId);
      state = AsyncValue.data(post);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
