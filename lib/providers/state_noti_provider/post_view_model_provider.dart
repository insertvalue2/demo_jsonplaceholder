
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/post_view_model.dart';
import '../provider/post_service_provider.dart';
import '../../models/post.dart';

/// PostViewModel의 인스턴스를 제공하는 Riverpod Provider입니다.
/// PostService를 주입받아 ViewModel을 초기화합니다.
final postViewModelProvider = StateNotifierProvider<PostViewModel, List<Post>>((ref) {
  // postServiceProvider를 통해 PostService 인스턴스를 가져옵니다.
  final postService = ref.read(postServiceProvider);
  // PostViewModel을 생성하고 반환합니다.
  return PostViewModel(postService);
});

/**
 * API를 사용하는 객체(서비스 클래스): Provider를 사용하여 전역에서 관리하고 재사용합니다.
 * ViewModel 클래스: StateNotifierProvider를 사용하여 상태를 관리하고, UI와 데이터를 연결합니다.
 */