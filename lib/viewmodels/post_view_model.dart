

// ViewModel은 UI와 데이터를 연결해주는 역할을 합니다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/models/post.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/services/post_service.dart';

// 만들어서 리버팟 창고로 넣어 둘 예정 !

// 고정 상태 제공(Provieder) ,
// StateNotifier(창고 관리자) 여기서는 List<Post> 타입의 상태를 관리합니다.
// 리버팟 사용 정리
// Providers --> 보통 의존성 주입이 필요할 때, 불변 객체를 제공할 때 사용합니다
// Notifiers --> 상태 관리(객체의 상태)와 비즈니스 로직 처리(API 호츨통한 데이터 가져오기 .. 등등)가 필요할 때 사용합니다.
class PostViewModel extends StateNotifier<List<Post>> {
  // !! 중요
  // 부모 클래스에(StateNotifier) T _state --> getter --> state 로 사용 가능 --> 결국 List<Post> 가 된다.

  // DIP (통신 요청을 담당하는 객체를 선언)
  final PostService _postService;

  // 통신 요청 시 발생할 수 있는 여러 응답 상태(로딩, 성공, 오류)가 있다.
  // 지금은 로딩상태, 오류 메세지 상태는 따로 관리 하지 말자. 추후 추가해 보자.

  PostViewModel(this._postService) : super([]) {
    // 생성자 바디
  }

  // 뷰모델에 역할 -->  뷰에 전달할 데이터를 마련하고 관리 한다.


  /// 포스트 데이터를 가져와 상태를 업데이트하는 메서드입니다.
  // 네트워크 작업 후에 내부 상태(state)를 업데이트합니다.
  // 하지만 함수 자체가 호출자에게 반환해야 할 값은 없습니다.
  // 상태는 이미 ViewModel 내부에서 관리되므로, 외부로 값을 반환할 필요가 없습니다.
  Future<void> fetchPosts() async {
    try {
      // PostService를 통해 포스트 데이터를 가져옵니다.
      final posts = await _postService.fetchPosts();
      // 가져온 포스트 데이터를 상태에 할당합니다.
      state = posts;
    } catch (e) {
      // 에러가 발생한 경우, 현재는 단순히 빈 리스트로 상태를 초기화합니다.
      // 추후 에러 상태를 관리할 수 있습니다.
      state = [];
    }
  }

  /// 새로운 포스트를 생성하는 메서드입니다.
  Future<void> createPost(Post post) async {
    try {
      final newPost = await _postService.createPost(post);

      // 현재 상태(포스트 리스트)에 새로운 포스트를 추가합니다.
      // state --> List<Post> ( 화면에 새롭게 추가된 게시글을 뿌려 주자)
      // ...state <-- 스프레드 연산자
      state = [...state, newPost];
      // state에 새로운 객체를 할당해야 하는 이유??
      // StateNotifier --> 새로운 객체로 할당될 때 상태 변경을 감지합니다.
      // state.add(newPost) 를 했다고 해서 새로운 객체가 할당된 것은 아니기 때문에
      // StateNotifier 는 값이 변경 되었다고 감지할 수 없다
    } catch (e) {
      print("createPost : $e");
      // 에러가 발생한 경우, 현재는 아무 작업도 하지 않습니다.
      // 추후 에러 상태를 관리할 수 있습니다.
    }
  }

  /// 기존 포스트를 업데이트하는 메서드입니다.
  Future<void> updatePost(Post updatedPost) async {

    try {
      // PostService를 통해 포스트를 업데이트합니다.
      final post = await _postService.updatePost(updatedPost);

      // 1단계
      // 새로운 리스트를 생성합니다.
      List<Post> updatedPosts = [];

      // 현재 상태(state)에 있는 모든 포스트를 순회합니다. (state -> List<Post>
      for (final p in state) {
        if (p.id == post.id) {
          // 만약 포스트의 ID가 업데이트된 포스트의 ID와 같다면, 업데이트된 포스트를 추가합니다.
          updatedPosts.add(post);
        } else {
          // 그렇지 않다면 기존 포스트를 그대로 추가합니다.
          updatedPosts.add(p);
        }
      }

      // 상태(state)를 업데이트된 포스트 리스트로 변경합니다.(새로운 List<Post> 객체 할당)
      state = updatedPosts;

      // 2단계 코드
      // 현재 상태에서 해당 포스트를 찾아 업데이트합니다.
      //state = state.map((p) => p.id == post.id ? post : p).toList();
    } catch (e) {
      // 추후 에러 상태를 관리
    }
  }

  /// 특정 포스트를 삭제하는 메서드입니다.
  Future<void> deletePost(int id) async {
    try {
      // PostService를 통해 포스트를 삭제합니다.
      await _postService.deletePost(id);

      // 1단계
      // 새로운 리스트를 생성합니다.
      List<Post> updatedPosts = [];

      // 현재 상태(state)에 있는 모든 포스트를 순회합니다.
      for (final p in state) {
        if (p.id != id) {
          // 포스트의 ID가 삭제하려는 ID와 다르면 리스트에 추가합니다.
          updatedPosts.add(p);
        }
        // 포스트의 ID가 삭제하려는 ID와 같으면 리스트에 추가하지 않습니다.
        // 즉, 해당 포스트를 제거하게 됩니다.
      }

      // 상태(state)를 업데이트된 포스트 리스트로 변경합니다.
      state = updatedPosts;

      // 2단계
      // 현재 상태에서 해당 포스트를 제거합니다.
      //state = state.where((p) => p.id != id).toList();
    } catch (e) {
      // 에러가 발생한 경우, 현재는 아무 작업도 하지 않습니다.
      // 추후 에러 상태를 관리할 수 있습니다.
    }
  }

}



