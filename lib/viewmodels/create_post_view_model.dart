
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class CreatePostViewModel extends StateNotifier<Post> {
  // 핵심 로직은 서버측에 데이터를 송신하고 응답 받는다
      // postService 클래스가 필요하다.
      // DI 할 수 있도록 리버팟을 활용해서 쉽게 가져올 수 있다.
  // 사용자가 위 작업을 할 수 있는 UI를 만들 때 사용할 수 있는 데이터(상태)를 관리한다.
  // 1
  //CreatePostViewModel(super.state);
  final PostService _postService;
  // 2
  // 생성자 ( 부모클래스에서 상태관리 할 수 있도록 초기값을 가지는 객체를 넘겨 주어야 한다.
  CreatePostViewModel(this._postService) : super(Post(title: '', body: ''));


  // 1. 통신 요청이기 때문에 응답 받는 데이터 타입은 Future 여야 한다.
  // 2. 서버측으로 보낼 데이터를 외부에서 주입 받아야 한다.
  // 반환 타입이 올바르게 수정된 메서드
  Future<void> createPost(String title, String body) async {
    try {
      final newPost = await _postService.createPost(Post(title: title, body: body));
      state = newPost;
    } catch (e) {
      state = Post(title: '', body: '');
      print('오류 메시지: ${e.toString()}');
    }
  }

}
