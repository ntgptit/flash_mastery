import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';

class GetDecksUseCase {
  final DeckRepository repository;

  const GetDecksUseCase(this.repository);

  Future<Either<Failure, List<Deck>>> call(String? folderId) {
    return repository.getDecks(folderId: folderId);
  }
}

class CreateDeckUseCase {
  final DeckRepository repository;

  const CreateDeckUseCase(this.repository);

  Future<Either<Failure, Deck>> call(CreateDeckParams params) {
    return repository.createDeck(
      name: params.name,
      description: params.description,
      folderId: params.folderId,
    );
  }
}

class UpdateDeckUseCase {
  final DeckRepository repository;

  const UpdateDeckUseCase(this.repository);

  Future<Either<Failure, Deck>> call(UpdateDeckParams params) {
    return repository.updateDeck(
      id: params.id,
      name: params.name,
      description: params.description,
      folderId: params.folderId,
    );
  }
}

class DeleteDeckUseCase {
  final DeckRepository repository;

  const DeleteDeckUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteDeck(id);
  }
}

class CreateDeckParams {
  final String name;
  final String? description;
  final String? folderId;

  const CreateDeckParams({
    required this.name,
    this.description,
    this.folderId,
  });
}

class UpdateDeckParams {
  final String id;
  final String? name;
  final String? description;
  final String? folderId;

  const UpdateDeckParams({
    required this.id,
    this.name,
    this.description,
    this.folderId,
  });
}
