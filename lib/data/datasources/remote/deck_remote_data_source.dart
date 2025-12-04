import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/models/deck_model.dart';

abstract class DeckRemoteDataSource {
  Future<List<DeckModel>> getDecks({String? folderId, String? sort});
  Future<DeckModel> getDeckById(String id);
  Future<DeckModel> createDeck(DeckModel deck);
  Future<DeckModel> updateDeck(String id, DeckModel deck);
  Future<void> deleteDeck(String id);
  Future<List<DeckModel>> searchDecks(String query, {String? folderId});
}

class DeckRemoteDataSourceImpl implements DeckRemoteDataSource {
  DeckRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<DeckModel>> getDecks({String? folderId, String? sort}) async {
    final response = await dio.get(
      ApiConstants.decks,
      queryParameters: {
        if (folderId != null) 'folderId': folderId,
        if (sort != null) 'sort': sort,
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
    if (query.isEmpty) return getDecks(folderId: folderId);
    final all = await getDecks(folderId: folderId);
    final lower = query.toLowerCase();
    return all
        .where(
          (d) =>
              d.name.toLowerCase().contains(lower) ||
              (d.description ?? '').toLowerCase().contains(lower),
        )
        .toList();
  }
}
