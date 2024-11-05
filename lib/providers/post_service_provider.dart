
// PostServiceImpl의 인스턴스를 제공하는 Riverpod Provider입니다
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/providers/dio_provider.dart';
import 'package:jsonplaceholder_riverpod_mvvm_v1/services/post_service_impl.dart';


// 중앙 집중식 의존성 주입(DI)을 위해 PostServiceImpl 객체를 Provider를 사용해서 관리합니다.
// Provider (불변 객체 제공)
// PostServiceImpl 객체를 애플리케이션 전역에서 사용할 수 있도록 제공합니다.

// (ref) { ... }는 익명 함수이며, ref는 Riverpod에서 제공하는 ProviderRef 객체입니다.
// ref를 통해 프로바이더 내에서 다른 프로바이더를 읽거나 라이프사이클을 관리할 수 있습니다.
final postServiceProvider = Provider<PostServiceImpl>((ref) {
  // dioProvider를 통해 Dio 인스턴스를 가져옵니다.
  final dio = ref.read(dioProvider);
  // PostServiceImpl를 생성하고 반환합니다.
  return PostServiceImpl(dio);
});









