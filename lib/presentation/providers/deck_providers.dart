import 'package:flash_mastery/core/providers/core_providers.dart';
import 'package:flash_mastery/data/datasources/local/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/remote/deck_remote_data_source.dart';
import 'package:flash_mastery/data/repositories/deck_repository_impl.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
DeckLocalDataSource deckLocalDataSource(Ref ref) {
  return DeckLocalDataSourceImpl(db: ref.watch(appDatabaseProvider));
}

@riverpod
DeckRemoteDataSource deckRemoteDataSource(Ref ref) {
  return DeckRemoteDataSourceImpl(dio: ref.watch(dioProvider));
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
DeckRepository deckRepository(Ref ref) {
  return DeckRepositoryImpl(
    remoteDataSource: ref.watch(deckRemoteDataSourceProvider),
  );
}
