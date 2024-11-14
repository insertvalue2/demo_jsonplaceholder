import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod  매우 다재다능한 상태 관리 및 의존성 주입(DI) 프레임워크로,
/// 단순히 UI 관련 상태 관리에 국한되지 않습니다.
///
///  의존성 제공: 중앙화된 DI 시스템으로 작동하여 애플리케이션 전반에 걸쳐 서비스, 리포지토리, 컨트롤러 등의 의존성을 주입할 수 있습니다.
///  애플리케이션 상태 관리: UI와 관련이 있든 없든, 일시적 상태와 지속적인 상태를 모두 처리할 수 있습니다.

/// Dio 인스턴스를 제공하는 Riverpod Provider입니다.
/// 프로젝트 전반에서 Dio를 사용하여 HTTP 요청을 수행할 수 있습니다.
///
/// 기본 설정에서 Dio는 HTTP 응답의 상태 코드가 200~299 범위가 아닐 경우, 요청이 실패한 것으로 간주하고 DioError 예외를 발생시킵니다.
final dioProvider = Provider<Dio>((ref) {
// Dio의 기본 설정을 포함하는 BaseOptions 객체를 생성합니다.
  final baseOptions = BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com', // API의 기본 URL 설정
    connectTimeout: const Duration(seconds: 5), // 연결 시간 초과 (초 단위)
    receiveTimeout: const Duration(seconds: 3), // 응답 시간 초과 (초 단위)
    validateStatus: (status) {
      // 모든 상태 코드를 허용하고 예외를 발생시키지 않음
      return true;
    },
    headers: {
      'Content-Type': 'application/json', // 요청 헤더 설정
// JWT 토큰이 필요한 경우, 여기에 'Authorization': 'Bearer <token>'을 추가할 수 있습니다.
// 예를 들어:
// 'Authorization': 'Bearer your_jwt_token_here',
    },
  );

// Dio 인스턴스를 생성하고 기본 설정을 적용합니다.
  final dio = Dio(baseOptions);

// 인터셉터를 추가하지 않습니다. JWT 토큰이 필요한 경우, DTO 클래스에 추가하거나 다른 방법으로 관리할 수 있습니다.
// 필요에 따라 추가 설정을 여기에 추가할 수 있습니다.

  return dio;
});
