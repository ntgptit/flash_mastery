import 'package:flash_mastery/core/providers/core_providers.dart';
import 'package:flash_mastery/data/datasources/local/deck_local_data_source.dart';
import 'package:flash_mastery/data/repositories/deck_repository_impl.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';
import 'package:flash_mastery/presentation/providers/folder_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
DeckLocalDataSource deckLocalDataSource(Ref ref) {
  return DeckLocalDataSourceImpl(db: ref.watch(appDatabaseProvider));
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
DeckRepository deckRepository(Ref ref) {
  return DeckRepositoryImpl(
    deckLocalDataSource: ref.watch(deckLocalDataSourceProvider),
    folderLocalDataSource: ref.watch(folderLocalDataSourceProvider),
  );
}
