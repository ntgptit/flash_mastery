import 'package:flash_mastery/core/providers/core_providers.dart';
import 'package:flash_mastery/data/datasources/remote/study_session_remote_data_source.dart';
import 'package:flash_mastery/data/repositories/study_session_repository_impl.dart';
import 'package:flash_mastery/domain/repositories/study_session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_session_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
StudySessionRemoteDataSource studySessionRemoteDataSource(Ref ref) {
  return StudySessionRemoteDataSourceImpl(dio: ref.watch(dioProvider));
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
StudySessionRepository studySessionRepository(Ref ref) {
  return StudySessionRepositoryImpl(
    remoteDataSource: ref.watch(studySessionRemoteDataSourceProvider),
  );
}

