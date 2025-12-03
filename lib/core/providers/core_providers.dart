import 'package:dio/dio.dart';
import 'package:flash_mastery/core/network/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

/// Provider for Dio client instance
@riverpod
DioClient dioClient(Ref ref) {
  return DioClient();
}

/// Provider for accessing Dio instance
@riverpod
Dio dio(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.dio;
}
