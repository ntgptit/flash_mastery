import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
import 'package:flash_mastery/data/models/import_summary_model.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';

abstract class DeckRemoteDataSource {
  Future<List<DeckModel>> getDecks({
    String? folderId,
    String? sort,
    String? query,
    int page,
    int size,
  });
  Future<DeckModel> getDeckById(String id);
  Future<DeckModel> createDeck(DeckModel deck);
  Future<DeckModel> updateDeck(String id, DeckModel deck);
  Future<void> deleteDeck(String id);
  Future<List<DeckModel>> searchDecks(String query, {String? folderId});
  Future<ImportSummaryModel> importDecks({
    required String folderId,
    required String type,
    required String filePath,
    required String fileName,
  });
}

class DeckRemoteDataSourceImpl implements DeckRemoteDataSource {
  DeckRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<DeckModel>> getDecks({
    String? folderId,
    String? sort,
    String? query,
    int page = 0,
    int size = 20,
  }) async {
    final response = await dio.get(
      ApiConstants.decks,
      queryParameters: {
        if (folderId != null) 'folderId': folderId,
        if (sort != null) 'sort': sort,
        if (query != null && query.isNotEmpty) 'q': query,
        'page': page,
        'size': size,
      },
    );
    if (response.statusCode == 200) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data.map(DeckModel.fromJson).toList();
    }
    throw ServerException(
      message: response.statusMessage ?? 'Failed to load decks',
    );
  }

  @override
  Future<DeckModel> getDeckById(String id) async {
    final response = await dio.get(ApiConstants.deckById(id));
    if (response.statusCode == 200) {
      return DeckModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Deck not found');
    }
    throw ServerException(
      message: response.statusMessage ?? 'Failed to load deck',
    );
  }

  @override
  Future<DeckModel> createDeck(DeckModel deck) async {
    final response = await dio.post(
      ApiConstants.createDeck,
      data: {
        'name': deck.name,
        'description': deck.description,
        'folderId': deck.folderId,
        'type': (deck.type ?? FlashcardType.vocabulary).name.toUpperCase(),
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return DeckModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(
      message: response.statusMessage ?? 'Failed to create deck',
    );
  }

  @override
  Future<DeckModel> updateDeck(String id, DeckModel deck) async {
    final response = await dio.put(
      ApiConstants.updateDeck(id),
      data: {
        'name': deck.name,
        'description': deck.description,
        'folderId': deck.folderId,
        'type': (deck.type ?? FlashcardType.vocabulary).name.toUpperCase(),
      },
    );
    if (response.statusCode == 200) {
      return DeckModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Deck not found');
    }
    throw ServerException(
      message: response.statusMessage ?? 'Failed to update deck',
    );
  }

  @override
  Future<void> deleteDeck(String id) async {
    final response = await dio.delete(ApiConstants.deleteDeck(id));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Deck not found');
    }
    throw ServerException(
      message: response.statusMessage ?? 'Failed to delete deck',
    );
  }

  @override
  Future<List<DeckModel>> searchDecks(String query, {String? folderId}) async {
    return getDecks(folderId: folderId, query: query, page: 0, size: 50);
  }

  @override
  Future<ImportSummaryModel> importDecks({
    required String folderId,
    required String type,
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'type': type,
    });
    final response = await dio.post(
      ApiConstants.importDecks(folderId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    if (response.statusCode == 200) {
      return ImportSummaryModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to import decks');
  }
}
