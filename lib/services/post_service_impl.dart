import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/models/post.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/services/post_service.dart';

// Post 관련 API 통신을 담당하는 서비스
class PostServiceImpl implements PostService {
  // 멤버 변수 선언
  final Dio _dio;

  // 의존 주입 DIP
  // PostServiceImpl(this._dio);
  // 선택 옵션(위치 기반 매개변수 선언 방식)
  PostServiceImpl([Dio? dio]) : _dio = dio ?? Dio();

  @override
  Future<Post> createPost(Post post) async {
    // _dio 클래스 기본 설정을 다룬 파일에 미리 하자.
    // 왜? albums 부분(도메인)을 개발할 때 또 dio 클래스 사용해야 함.
    // 그럼 -----> Dio 인스턴스 하나 생성해서 여러 서비스(API호출) 사용하자.
    // 싱글톤 패턴 개념과 유사...(같은 것은 아님) --> riverpod 사용하자.
    try {
      // 'posts' 엔드포인트로 POST 요청을 보냅니다.
      final response = await _dio.post(
        '/posts',
        data: post.toJson(), // 포스트 데이터를 JSON 형식으로 전송합니다.
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('포스트 생성 후 응답 확인 : ${response.data}');
        return Post.fromJson(response.data);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception("Error created post : $e");
    }
  }

  // DELETE 요청을 보내어 특정 게시글을 삭제 요청
  @override
  Future<void> deletePost(int id) async {
    try {
      final response = await _dio.delete("/posts/$id");
      // 응답 상태 코드가 200인 경우 삭제 성공
      if (response.statusCode != 200) {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Error deleting post : $e');
    }
  }

  @override
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _dio.get('/posts');
      // 응답 상태 코드가 200인 경우 데이터를 파싱 합니다.
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        // 각 JSON 객체를 Post  모델로 변환하여 리스트로 반환합니다.
        print("---------코드확인 1--------------------");
        print("data: $data");
        print("---------코드확인 2--------------------");
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생 시 예외를 던집니다.
      throw Exception('Error fetching posts: $e');
    }
    // Dart에서 아직 구현되지 않은 메서드나 기능을 호출하려 할 때 발생하는 에러
    throw UnimplementedError();
  }

  @override
  Future<Post> updatePost(Post post) async {
    try {
      // 'posts/{id} 엔드 포인트로 put
      final response = await _dio.put(
        '/posts/${post.id}',
         data: post.toJson()
      );

      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        // 상태 코드가 200 이 아닐 때 예외 던짐
        throw Exception('Failed to update post');
      }
    } catch (e) {
      throw Exception('Error updating post : $e');
    }
  }

  @override
  Future<Post> fetchPostById(int id) async {
    try {
      final response = await _dio.get('/posts/$id');
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }
}
