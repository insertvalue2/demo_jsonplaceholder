

import 'package:jsonplaceholder_riverpod_mvvm_v1/models/post.dart';

abstract class PostService {

  // 모든 게시글 목록을 가져옵니다.
  Future<List<Post>> fetchPosts();

  // 새로운 게시글을 생성합니다.
  Future<Post> createPost(Post post);

  // 기존 게시글을 수정합니다.
  Future<Post> updatePost(Post post);

  // 득정 게시글을 삭제합니다.
  Future<void> deletePost(int id);

}