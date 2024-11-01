import 'package:equatable/equatable.dart';

/// Post 데이터를 표현하는 모델 클래스를 정의합니다.
/// 이 클래스는 서버로부터 받은 JSON 데이터를 Dart 객체로 변환하거나,
/// Dart 객체를 JSON으로 변환할 때 사용됩니다.

/// Post 모델 클래스입니다.
/// 서버로부터 받은 JSON 데이터를 담고 있으며, 값 기반 비교를 지원합니다.
class Post extends Equatable {
  int? userId;
  int? id;
  final String title;
  final String body;

  Post({this.userId, this.id, required this.title, required this.body});

  /// JSON 데이터를 post 객체로 변환하는 이름이 있는 생성자
  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        body = json['body'];

  // JSON 데이터를 post 객체로 변환하는 팩토릭 생성자
  // factory Post.fromJson(Map<String, dynamic> json) {
  //   return Post(
  //       userId: json['userId'],
  //       id: json['id'],
  //       title: json['title'],
  //       body: json['json']);
  // }

  /// Post 객체를 JSON 데이터로 변환하는 메서드입니다.
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }

  /// Equatable 패키지는 객체의 값 기반 비교를 간편하게 구현할 수 있도록 합니다.

  /// Equatable의 요구사항 -> List<Object?>
  /// 객체의 동등성을 판단할 때 이 리스트에 포함된 모든 필드를 순차적으로 비교하기 때문입니다.
  /// ?는 각 요소가 null일 수 있음을 나타냄.
  /// 값 기반 비교: Equatable은 props에 포함된 모든 필드를 사용하여 두 객체의 동등성을 판단한다.
  @override
  List<Object?> get props => [userId, id, title, body];
}
