
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/post.dart';

void main() async {
  // Dio 인스턴스를 생성하고 기본 설정을 적용합니다.
  final dio = createDio();

  // 비동기 함수를 호출할 때는 await를 사용해야 합니다.
  //await createPost(dio);
  await fetchPosts(dio);
}

// Dio 인스턴스를 생성하는 함수
Dio createDio() {
  final baseOptions = BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com', // API의 기본 URL 설정
    connectTimeout: const Duration(seconds: 5), // 연결 시간 초과
    receiveTimeout: const Duration(seconds: 3), // 응답 시간 초과
    headers: {
      'Content-Type': 'application/json', // 요청 헤더 설정
      // 'Authorization': 'Bearer your_jwt_token_here', // JWT 토큰이 필요한 경우 추가
    },
  );
  return Dio(baseOptions);
}

// 새로운 게시물을 생성하는 함수
Future<void> createPost(Dio dio) async {
  final post = Post(userId: 1, title: '내가 넣은 제목이 맞아?', body: '가나다라마바사');

  try {
    final response = await dio.post(
      '/posts',
      data: post.toJson(),
    );

    print('---------------------------');
    print('Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');
  } catch (e) {
    print('Error occurred while creating post: $e');
  }
}

// 게시물 목록을 가져오는 함수
Future<void> fetchPosts(Dio dio) async {
  try {
    final response = await dio.get('/posts');

    print('---------------------------');
    print('Status Code: ${response.statusCode}');

    List<Post> posts = (response.data as List)
        .map((json) => Post.fromJson(json))
        .toList();

    print('Fetched Posts:');
    for (var post in posts) {
      print(post);
    }
  } catch (e) {
    print('Error occurred while fetching posts: $e');
  }
}