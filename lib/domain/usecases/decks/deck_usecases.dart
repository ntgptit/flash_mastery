import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/core/usecases/usecase.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';

class GetDecksUseCase extends UseCase<List<Deck>, GetDecksParams> {
  final DeckRepository repository;

  GetDecksUseCase(this.repository);

  @override
  Future<Either<Failure, List<Deck>>> call(GetDecksParams params) {
    return repository.getDecks(
      folderId: params.folderId,
      sort: params.sort,
      query: params.query,
      page: params.page,
      size: params.size,
    );
  }
}

class GetDeckByIdUseCase extends UseCase<Deck, String> {
  final DeckRepository repository;

  GetDeckByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Deck>> call(String id) {
    return repository.getDeckById(id);
  }
}

class SearchDecksUseCase extends UseCase<List<Deck>, SearchDecksParams> {
  final DeckRepository repository;

  SearchDecksUseCase(this.repository);

  @override
  Future<Either<Failure, List<Deck>>> call(SearchDecksParams params) {
    return repository.searchDecks(params.query, folderId: params.folderId);
  }
}

class CreateDeckUseCase extends UseCase<Deck, CreateDeckParams> {
  final DeckRepository repository;

  CreateDeckUseCase(this.repository);

  @override
  Future<Either<Failure, Deck>> call(CreateDeckParams params) async {
    final trimmedName = params.name.trim();
    final trimmedDescription = params.description?.trim();

    final validationFailure = _validateDeckFields(
      trimmedName,
      trimmedDescription,
    );
    if (validationFailure != null) return Left(validationFailure);

    return repository.createDeck(
      name: trimmedName,
      description: trimmedDescription,
      folderId: params.folderId,
    );
  }
}

class UpdateDeckUseCase extends UseCase<Deck, UpdateDeckParams> {
  final DeckRepository repository;

  UpdateDeckUseCase(this.repository);

  @override
  Future<Either<Failure, Deck>> call(UpdateDeckParams params) async {
    final trimmedName = params.name?.trim();
    final trimmedDescription = params.description?.trim();

    final validationFailure = _validateDeckFields(
      trimmedName ?? '',
      trimmedDescription,
      allowEmptyName: trimmedName == null,
    );
    if (validationFailure != null) return Left(validationFailure);

    return repository.updateDeck(
      id: params.id,
      name: trimmedName,
      description: trimmedDescription,
      folderId: params.folderId,
    );
  }
}

class DeleteDeckUseCase extends UseCase<void, String> {
  final DeckRepository repository;

  DeleteDeckUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteDeck(id);
  }
}

class CreateDeckParams {
  final String name;
  final String? description;
  final String? folderId;

  const CreateDeckParams({required this.name, this.description, this.folderId});
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

class SearchDecksParams {
  final String query;
  final String? folderId;

  const SearchDecksParams({required this.query, this.folderId});
}

class GetDecksParams {
  final String? folderId;
  final String? sort;
  final String? query;
  final int page;
  final int size;

  const GetDecksParams({
    this.folderId,
    this.sort,
    this.query,
    this.page = 0,
    this.size = 20,
  });
}

Failure? _validateDeckFields(
  String name,
  String? description, {
  bool allowEmptyName = false,
}) {
  if (!allowEmptyName && name.isEmpty) {
    return ValidationFailure(message: ErrorMessages.deckNameRequired);
  }

  if (name.isNotEmpty && name.length < AppConstants.minDeckNameLength) {
    return ValidationFailure(
      message: ErrorMessages.textTooShort(AppConstants.minDeckNameLength),
    );
  }

  if (name.isNotEmpty && name.length > AppConstants.maxDeckNameLength) {
    return ValidationFailure(
      message: ErrorMessages.textTooLong(AppConstants.maxDeckNameLength),
    );
  }

  if (description != null &&
      description.length > AppConstants.maxDeckDescriptionLength) {
    return ValidationFailure(
      message: ErrorMessages.textTooLong(AppConstants.maxDeckDescriptionLength),
    );
  }

  return null;
}
