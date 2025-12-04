import 'package:flash_mastery/data/datasources/local/flashcard_local_data_source.dart';
import 'package:flash_mastery/data/repositories/flashcard_repository_impl.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';
import 'package:flash_mastery/presentation/providers/deck_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
FlashcardLocalDataSource flashcardLocalDataSource(Ref ref) {
  return FlashcardLocalDataSourceImpl();
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
FlashcardRepository flashcardRepository(Ref ref) {
  return FlashcardRepositoryImpl(
    flashcardLocalDataSource: ref.watch(flashcardLocalDataSourceProvider),
    deckLocalDataSource: ref.watch(deckLocalDataSourceProvider),
  );
}
