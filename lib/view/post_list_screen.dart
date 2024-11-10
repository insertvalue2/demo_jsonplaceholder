import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/providers/post_view_model_provider.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/view/create_post_screen.dart';

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
                  trailing: IconButton(
                      onPressed: () async  {
                        bool confirm = await showDialog(context: context, builder: (context) => AlertDialog(
                          title: const Text('삭제'),
                          content: Text('${post.title} 를 삭제 하시겠습니까?'),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.of(context).pop(false);
                            }, child: const Text('취소')),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('삭제'),
                            )

                          ],
                        ),);
                        if (confirm) {
                          // ViewModel의 deletePost 메서드 호출
                          await ref.read(postViewModelProvider.notifier).deletePost(post.id!);

                          // 삭제 완료 후 스낵바로 피드백 제공
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('포스트 "${post.title}"이(가) 삭제되었습니다.')),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
        child: const Icon(Icons.add), // 버튼의 아이콘을 설정합니다.
      ),
    );
  }
}
