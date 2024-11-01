// 1. Dio 클래스가 있어야 PostServiceImpl 인스턴스에 동작들을 테스트 할 수 있다.
// 1.1 하지만 실제 네트워크 통신으로 테스트 하는 것은 비효율적이다.

// 1 - 결론 ( Dio 가짜 객체가 필요하다. )
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/models/post.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/services/post_service.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/services/post_service_impl.dart';
import 'package:mocktail/mocktail.dart';

// Dio 클래스를 모킹하기 위한 가짜(Mock) 클래스 정의
// 테스트에서 실제 객체나 의존성을 가짜(Mock) 객체로 대체하여
// 코드의 특정 부분을 독립적으로 검증하는 기술입니다.
class MockDio extends Mock implements Dio {}

void main() {
  // 테스트에 사용할 변수 선언 합니다.
  late MockDio mockDio; // 모팅된 Dio 인스턴스
  late PostService postService; // 테스트할 클래스 선언(추상)

  // 각 테스트가 실행되기 전에 실행되는 설정 함수
  setUp(() {
    mockDio = MockDio();

    postService = PostServiceImpl(mockDio);
  });

  // 'PostServiceImpl'에 대한 테스트 그룹을 시작합니다.
  group('PostServiceImpl', () {
    // 'createPost' 메서드가 성공적으로 실행될 때의 테스트
    test('createPost 성공 시 Post 반환', () async {
      // 테스트에 사용할 Post 객체를 생성합니다.
      final post =
          Post(userId: 1, id: 101, title: 'Test Title', body: 'Test Body');

      // Dio의 post 메서드가 호출되었을 때 반환할 모킹된 응답을 설정합니다.
      when(() => mockDio.post(
            '/posts', // 요청할 엔드포인트
            data: post.toJson(), // 요청에 포함될 데이터(JSON 형식)
          )).thenAnswer(
        (_) async => Response(
          data: post.toJson(), // 응답 데이터
          statusCode: 201, // HTTP 상태 코드 (201: 생성됨)
          requestOptions: RequestOptions(path: '/posts'), // 요청 옵션
        ),
      );

      // 실제 메서드를 호출하고 결과를 받아옵니다.
      final result = await postService.createPost(post);

      // 결과가 예상한 대로인지 확인합니다.
      expect(result, equals(post)); // 결과가 원래의 post와 동일한지 확인
      expect(result.userId, equals(1)); //
      // expect(result.id, equals(1011)); // 결과가 원래의 post와 동일한지 확인

      // Dio의 post 메서드가 정확히 한 번 호출되었는지 검증합니다.
      verify(() => mockDio.post('/posts', data: post.toJson())).called(1);
    });

    // 'createPost' 메서드가 실패할 때의 테스트
    test('createPost 실패 시 예외 발생', () async {
      // 테스트에 사용할 Post 객체를 생성합니다.
      final post =
          Post(userId: 1, id: 101, title: 'Test Title', body: 'Test Body');

      // Dio의 post 메서드가 호출되었을 때 예외를 던지도록 설정합니다.
      when(() => mockDio.post(
            '/posts', // 요청할 엔드포인트
            data: post.toJson(), // 요청에 포함될 데이터(JSON 형식)
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/posts'), // 요청 옵션
        error: 'Failed to create post', // 에러 메시지
        type: DioExceptionType.connectionError, // 에러 타입
      ));

      // 메서드를 호출하고 예외가 발생하는지 확인합니다.
      expect(
        () async => await postService.createPost(post), // 비동기 함수 호출
        throwsA(isA<Exception>()), // Exception 타입의 예외가 발생하는지 확인
      );

      // Dio의 post 메서드가 정확히 한 번 호출되었는지 검증합니다.
      verify(() => mockDio.post('/posts', data: post.toJson())).called(1);
    });

    test("deletePost 확인 ", () {
      // given
      final int postId = 101;

      // when
      when(() => mockDio.delete('/posts$postId')).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/delete$postId'),
        ),
      );

      // then
      // deletePost 호출 시, 예외가 발생하는지 확인합니다.
      expect(() => postService.deletePost(postId), throwsException);

      // delete 메서드가 정확히 한 번 호출되었는지 검증합니다.
      // verify  특정 메서드가 예상대로 호출되었는지를 확인하는 데 사용
      verify(() => mockDio.delete('/posts/$postId')).called(1);
      // 메서드 호출 횟수를 검증하는 것은 테스트 대상 클래스가 의도한 대로 의존성 객체와
      // 상호작용하는지를 확인데 그 이유가 이 ㅆ다.
    });

    test("fetchPosts 목록 확인", () async {
      // given
      final postsJson = [
        {
          'userId': 1,
          'id': 1,
          'title': 'Post 1',
          'body': 'Content 1',
        },
        {
          'userId': 1,
          'id': 2,
          'title': 'Post 2',
          'body': 'Content 2',
        },
      ];

      // when
      when(() => mockDio.get('/posts')).thenAnswer((_) async => Response(
          data: postsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts')));

      // Act (When): 메서드를 호출하여 결과를 받습니다.
      final result = await postService.fetchPosts();

      // then
      expect(result, isA<List<Post>>()); // 결과가 List<Post> 타입인지 확인
      expect(result.length, equals(2)); // 리스트의 길이가 2인지 확인
      expect(result[0].title, equals('Post 1')); // 첫 번째 포스트의 제목 확인
      expect(result[1].title, equals('Post 2')); // 두 번째 포스트의 제목 확인

      // 메서드 호출 여부 검증
      verify(() => mockDio.get('/posts')).called(1);
    });

    test('post put 테스트 ', () async {
      // given
      final int postId = 101;
      final post = Post(userId: 1, id: 101, title: "제목 수정1", body: "내용 수정1");

      // when
      when(() => mockDio.put('/posts/$postId', data: post.toJson())).thenAnswer(
        (_) async => Response(
          data: post,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$postId'),
        ),
      );
      // act
      final result = await postService.updatePost(post);
      // then
      // then: 결과가 예상한 대로인지 검증합니다.
      // Dart의 테스트 프레임워크에서 제공하는 **매처(matcher)**로, 객체가 특정 타입인지 확인할 때 사용합니다.
      expect(result, isA<Post>()); // 결과가 Post 타입인지 확인
      expect(result.title, equals('제목 수정1')); // 제목이 수정되었는지 확인
      expect(result.body, equals('내용 수정1')); // 내용이 수정되었는지 확인

    });
  });
}
