// lib/providers/detail_post_view_model_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post.dart';
import '../../viewmodels/detail_post_view_model.dart';
import '../provider/post_service_provider.dart';

// 특정 postId에 대한 DetailPostViewModel을 제공하는 Provider를 정의합니다.
// 이 Provider는 StateNotifierProvider를 기반으로 하며, family 수정자를 사용하여 외부 매개변수를 받을 수 있습니다.
final detailPostViewModelProvider =
StateNotifierProvider.family<DetailPostViewModel, AsyncValue<Post>, int>(
  // Provider를 생성하는 함수입니다.
  // ref: ProviderReference로, 다른 Provider를 읽거나 조작할 수 있습니다.
  // postId: family를 통해 전달받은 외부 매개변수로, 특정 포스트를 식별하는 데 사용됩니다.
        (ref, postId) {
      // postServiceProvider를 통해 PostService 인스턴스를 가져옵니다.
      // ref.read를 사용하여 다른 Provider의 상태나 객체를 읽을 수 있습니다.
      final postService = ref.read(postServiceProvider);

      // DetailPostViewModel 인스턴스를 생성하여 반환합니다.
      // 생성자에 postService와 postId를 전달하여 해당 포스트의 상세 정보를 가져올 수 있도록 합니다.
      return DetailPostViewModel(postService, postId);
    });
