import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/post.dart';

void main() async {

  final baseOptions = BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com', // API의 기본 URL 설정
    connectTimeout: const Duration(seconds: 5), // 연결 시간 초과 (초 단위)
    receiveTimeout: const Duration(seconds: 3), // 응답 시간 초과 (초 단위)
    headers: {
      'Content-Type': 'application/json', // 요청 헤더 설정
// JWT 토큰이 필요한 경우, 여기에 'Authorization': 'Bearer <token>'을 추가할 수 있습니다.
// 예를 들어:
// 'Authorization': 'Bearer your_jwt_token_here',
    },
  );

// Dio 인스턴스를 생성하고 기본 설정을 적용합니다.
  final dio = Dio(baseOptions);
  final post = Post(userId: 1, title: '내가 넣은 제목이 맞아?', body: '가나다라마바사');

  final response = await dio.post(
    '/posts',
    data: post.toJson(), // 포스트 데이터를 JSON 형식으로 전송합니다.
  );

  print('---------------------------');
  print(response.data);

} // end of main





