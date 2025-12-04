import 'package:flash_mastery/core/providers/core_providers.dart';
import 'package:flash_mastery/data/datasources/local/flashcard_local_data_source.dart';
import 'package:flash_mastery/data/datasources/remote/flashcard_remote_data_source.dart';
import 'package:flash_mastery/data/repositories/flashcard_repository_impl.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
FlashcardLocalDataSource flashcardLocalDataSource(Ref ref) {
  return FlashcardLocalDataSourceImpl(db: ref.watch(appDatabaseProvider));
}

@riverpod
FlashcardRemoteDataSource flashcardRemoteDataSource(Ref ref) {
  return FlashcardRemoteDataSourceImpl(dio: ref.watch(dioProvider));
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
FlashcardRepository flashcardRepository(Ref ref) {
  return FlashcardRepositoryImpl(
    remoteDataSource: ref.watch(flashcardRemoteDataSourceProvider),
  );
}
