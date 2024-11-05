import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/view/post_list_screen.dart';


void main() {
  runApp(ProviderScope(child: MyApp()));
}

/// MyApp은 애플리케이션의 루트 위젯입니다.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM with Riverpod and Dio', // 애플리케이션의 제목을 설정합니다.
      theme: ThemeData(
        primarySwatch: Colors.blue, // 애플리케이션의 테마를 설정합니다.
      ),
      home: PostListScreen(), // 포스트 리스트 화면으로 이동
    );
  }

}



