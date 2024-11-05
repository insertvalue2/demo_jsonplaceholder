import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/providers/post_view_model_provider.dart';

import '../models/post.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MVVM -> view 는 viewModel 만 바라 보면 된다.
    // postViewModelProvider를 통해 ViewModel의 상태(List<Post>)를 구독합니다.
    final posts = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'), // 앱 바의 제목을 설정합니다.
      ),
      body: posts.isEmpty
          ? Center(child: Text('No Posts Available')) // 포스트가 없을 경우 메시지를 표시합니다.
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
              ),
              itemCount: posts.length, // 포스트의 개수만큼 리스트 아이템을 생성합니다.
              itemBuilder: (context, index) {
                Post post = posts[index]; // 현재 인덱스의 포스트를 가져옵니다.
                return ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                  // 포스트의 제목을 표시합니다.
                  subtitle: Text(post.body),
                  // 포스트의 내용을 표시합니다.
                  onTap: () {
                    // 포스트를 눌렀을 때의 동작을 정의할 수 있습니다.
                    // 예: 포스트 상세 화면으로 이동하거나, 업데이트/삭제 기능을 구현할 수 있습니다.
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 플로팅 액션 버튼을 눌렀을 때의 동작을 정의할 수 있습니다.
          // 예: 새로운 포스트를 생성하는 화면으로 이동하거나, 다이얼로그를 열 수 있습니다.
        },
        child: const Icon(Icons.add), // 버튼의 아이콘을 설정합니다.
      ),
    );
  }
}
