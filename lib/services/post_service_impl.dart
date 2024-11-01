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
      if(response.statusCode == 201 || response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception("Error created post : $e");
    }
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(int id) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchPosts() {
    // TODO: implement fetchPosts
    throw UnimplementedError();
  }

  @override
  Future<Post> updatePost(Post post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }

}